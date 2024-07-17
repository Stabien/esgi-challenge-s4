package controllers

import (
	"net/http"
	"strconv"
	"strings"
	"time"

	"easynight/internal/db"
	"easynight/internal/firebase"
	"easynight/internal/models"
	"easynight/pkg/utils"

	"github.com/google/uuid"
	"github.com/labstack/echo/v4"
)

type EventInput struct {
	Title             string  `json:"title"`
	Description       string  `json:"description"`
	Banner            string  `json:"banner"`
	Image             string  `json:"image"`
	Date              string  `json:"date"`
	ParticipantNumber *int    `json:"participant_number"`
	Lat               float64 `json:"lat"`
	Lng               float64 `json:"lng"`
	Location          string  `json:"location"`
	Tag               string  `json:"tag"`
	Place             string  `json:"place"`
}

// @Summary Create a new event
// @Tags Event
// @Accept json
// @Produce json
// @Param event body EventInput true "Event input"
// @Success 200 {string} string "Event created successfully!"
// @Failure 400 {object} error "Bad request"
// @Failure 500 {object} error "Internal server error"
// @Router /event [post]
func CreateEvent(c echo.Context) error {
	bannerFile, err := c.FormFile("banner")

	if err != nil {
		return c.JSON(http.StatusUnprocessableEntity, map[string]string{"error": err.Error()})
	}

	bannerPath, err := utils.UploadFile(bannerFile)

	if err != nil {
		return c.JSON(http.StatusUnprocessableEntity, map[string]string{"error": err.Error()})
	}

	imageFile, err := c.FormFile("image")

	if err != nil {
		return c.JSON(http.StatusUnprocessableEntity, map[string]string{"error": err.Error()})
	}

	imagePath, err := utils.UploadFile(imageFile)

	if err != nil {
		return c.JSON(http.StatusUnprocessableEntity, map[string]string{"error": err.Error()})
	}

	participantNumber, err := strconv.Atoi(c.FormValue("participantNumber"))

	if err != nil {
		return c.JSON(http.StatusUnprocessableEntity, map[string]string{"error": err.Error()})
	}

	lat, err := strconv.ParseFloat(c.FormValue("lat"), 32)

	if err != nil {
		return c.JSON(http.StatusUnprocessableEntity, map[string]string{"error": err.Error()})
	}

	lng, err := strconv.ParseFloat(c.FormValue("lng"), 32)

	if err != nil {
		return c.JSON(http.StatusUnprocessableEntity, map[string]string{"error": err.Error()})
	}

	date, err := time.Parse(time.RFC3339, c.FormValue("date"))

	if err != nil {
		return c.JSON(http.StatusUnprocessableEntity, map[string]string{"error": err.Error()})
	}

	// Create new event object
	event := models.Event{
		Title:             c.FormValue("title"),
		Description:       c.FormValue("description"),
		Banner:            bannerPath,
		Image:             imagePath,
		Date:              date,
		ParticipantNumber: &participantNumber,
		Lat:               float32(lat),
		Lng:               float32(lng),
		Location:          c.FormValue("location"),
		Tag:               c.FormValue("tag"),
		Place:             c.FormValue("place"),
		Code:              utils.GenerateRandomString(6),
		IsPending:         true,
	}

	claims, err := utils.GetTokenFromHeader(c)
	if err != nil {
		return c.JSON(http.StatusBadRequest, map[string]string{"error": err.Error()})
	}

	userID := claims["id"].(string)

	// Insert event into database
	if err := db.DB().Create(&event).Error; err != nil {
		return err
	}

	// Insert association between organizer and event
	if err := db.DB().Table("organizer_events").Create(map[string]interface{}{
		"organizer_user_id": userID,
		"event_id":          event.ID,
	}).Error; err != nil {
		return err
	}

	// Return success message
	return c.String(http.StatusOK, "Event created successfully!")
}

// UpdateEvent met à jour partiellement un événement par ID
// @Summary Update an existing event
// @Tags Event
// @Accept json
// @Produce json
// @Param id path string true "Event ID"
// @Param event body EventInput true "Event input"
// @Success 200 {string} string "Event updated successfully!"
// @Failure 400 {object} error "Bad request"
// @Failure 404 {object} error "Event not found"
// @Failure 500 {object} error "Internal server error"
// @Router /event/{id} [patch]
func UpdateEvent(c echo.Context) error {
	// Get event ID from URL
	eventID := c.Param("id")

	claims, err := utils.GetTokenFromHeader(c)
	if err != nil {
		return c.JSON(http.StatusBadRequest, map[string]string{"error": err.Error()})
	}

	userID := claims["id"].(string)

	// Get event from database
	var event models.Event
	if err := db.DB().First(&event, "id = ?", eventID).Error; err != nil {
		return c.JSON(http.StatusNotFound, map[string]string{"error": "Event not found"})
	}

	// If the user is not the organizer of the event, return an error
	var count int64
	if err := db.DB().Table("organizer_events").Where("organizer_user_id = ? AND event_id = ?", userID, eventID).Count(&count).Error; err != nil {
		return err
	}

	if count == 0 {
		return c.JSON(http.StatusBadRequest, map[string]string{"error": "You are not the organizer of this event"})
	}

	bannerFile, err := c.FormFile("banner")

	if err != nil {
		return c.JSON(http.StatusBadRequest, map[string]string{"error": err.Error()})
	}

	bannerPath, err := utils.UploadFile(bannerFile)

	if err != nil {
		return c.JSON(http.StatusBadRequest, map[string]string{"error": err.Error()})
	}

	imageFile, err := c.FormFile("image")

	if err != nil {
		return c.JSON(http.StatusBadRequest, map[string]string{"error": err.Error()})
	}

	imagePath, err := utils.UploadFile(imageFile)

	if err != nil {
		return c.JSON(http.StatusBadRequest, map[string]string{"error": err.Error()})
	}

	participantNumber, err := strconv.Atoi(c.FormValue("participantNumber"))

	if err != nil {
		return c.JSON(http.StatusBadRequest, map[string]string{"error": err.Error()})
	}

	lat, err := strconv.ParseFloat(c.FormValue("lat"), 32)

	if err != nil {
		return c.JSON(http.StatusBadRequest, map[string]string{"error": err.Error()})
	}

	lng, err := strconv.ParseFloat(c.FormValue("lng"), 32)

	if err != nil {
		return c.JSON(http.StatusBadRequest, map[string]string{"error": err.Error()})
	}

	date, err := time.Parse(time.RFC3339, c.FormValue("date"))

	if err != nil {
		return c.JSON(http.StatusUnprocessableEntity, map[string]string{"error": err.Error()})
	}

	// Update event fields
	event.Title = c.FormValue("title")
	event.Description = c.FormValue("description")
	event.Banner = bannerPath
	event.Image = imagePath
	event.Date = date
	event.ParticipantNumber = &participantNumber
	event.Lat = float32(lat)
	event.Lng = float32(lng)
	event.Location = c.FormValue("location")
	event.Tag = c.FormValue("tag")
	event.Place = c.FormValue("place")

	// event.Date, err = time.Parse(time.RFC3339, updateInput.Date)

	if err := db.DB().Model(&event).Updates(&event).Error; err != nil {
		return err
	}

	// Send notification to inform users that the event has been updated
	err = firebase.SendNotificationToTopic()
	if err != nil {
		return c.String(http.StatusInternalServerError, err.Error())
	}

	return c.String(http.StatusOK, "Event updated successfully!")
}

type EventDetails struct {
	ID                uuid.UUID `json:"id"`
	Title             string    `json:"title"`
	Description       string    `json:"description"`
	Tag               string    `json:"tag"`
	Banner            string    `json:"banner"`
	Image             string    `json:"image"`
	Date              time.Time `json:"date"`
	Place             string    `json:"place"`
	Lat               float32   `json:"lat"`
	Lng               float32   `json:"lng"`
	Location          string    `json:"location"`
	ParticipantNumber *int      `json:"participant_number"`
	PlaceRestante     int       `json:"place_restante"`
	Code              string    `json:"code"`
}

// @Summary Get an event by ID
// @Tags Event
// @Accept json
// @Produce json
// @Param id path string true "Event ID"
// @Success 200 {object} interface{} "Event found"
// @Failure 400 {object} error "Bad request"
// @Failure 404 {object} error "Event not found"
// @Failure 500 {object} error "Internal server error"
// @Router /event/{id} [get]
func GetEvent(c echo.Context) error {
	eventID := c.Param("id")

	var event models.Event
	if err := db.DB().First(&event, "id = ?", eventID).Error; err != nil {
		return err
	}

	var reservations models.Reservation
	var count int64
	if err := db.DB().Model(&reservations).Where("event_id = ? AND deleted_at IS NULL", eventID).Count(&count).Error; err != nil {
		return err
	}

	bannerContent, err := utils.ReadAndEncodeFile("./" + event.Banner)

	if err != nil {
		return echo.NewHTTPError(http.StatusInternalServerError, err)
	}

	imageContent, err := utils.ReadAndEncodeFile("./" + event.Image)

	if err != nil {
		return echo.NewHTTPError(http.StatusInternalServerError, err)
	}

	// Map fields from Event to EventDetails
	eventDetails := EventDetails{
		ID:                event.ID,
		Title:             event.Title,
		Description:       event.Description,
		Tag:               event.Tag,
		Banner:            bannerContent,
		Image:             imageContent,
		Date:              event.Date,
		Place:             event.Place,
		Lat:               event.Lat,
		Lng:               event.Lng,
		Location:          event.Location,
		ParticipantNumber: event.ParticipantNumber,
		PlaceRestante:     *event.ParticipantNumber - int(count),
		Code:              event.Code,
	}

	return c.JSON(http.StatusOK, eventDetails)
}

type SimpleEvent struct {
	ID          uuid.UUID `json:"id"`
	Title       string    `json:"title"`
	Description string    `json:"description"`
	Tag         string    `json:"tag"`
	Banner      string    `json:"banner"`
	Image       string    `json:"image"`
	Date        time.Time `json:"date"`
	Place       string    `json:"place"`
	IsPending   bool      `json:"is_pending"`
}

// @Summary Get events
// @Tags Event
// @Accept json
// @Produce json
// @Param name query string false "Event name"
// @Param tag query string false "Event tag"
// @Success 200 {object} interface{} "Event found"
// @Failure 400 {object} error "Bad request"
// @Failure 404 {object} error "Event not found"
// @Failure 500 {object} error "Internal server error"
// @Router /events [get]
func GetAllEvents(c echo.Context) error {
	var events []models.Event
	var nameFilter string

	nameFilter = c.QueryParam("name")
	tagFilter := c.QueryParam("tag")
	today := time.Now().AddDate(0, 0, -1)

	claims, err := utils.GetTokenFromHeader(c)
	if err != nil {
		return c.JSON(http.StatusBadRequest, map[string]string{"error": err.Error()})
	}

	if claims["role"].(string) == "admin" {
		if err := db.DB().Find(&events).Error; err != nil {
			return c.JSON(http.StatusInternalServerError, map[string]string{"error": err.Error()})
		}
	} else if tagFilter != "" && nameFilter != "" {
		if err := db.DB().Where("(LOWER(title) LIKE ? OR LOWER(location) LIKE ?) AND tag = ? AND is_pending = false AND deleted_at IS NULL AND date >= ?", "%"+strings.ToLower(nameFilter)+"%", "%"+strings.ToLower(nameFilter)+"%", tagFilter, today).Find(&events).Error; err != nil {
			return c.JSON(http.StatusInternalServerError, map[string]string{"error": err.Error()})
		}
	} else if tagFilter != "" && nameFilter == "" {
		if err := db.DB().Where("tag = ? AND is_pending = false AND deleted_at IS NULL  AND date >= ?", tagFilter, today).Find(&events).Error; err != nil {
			return c.JSON(http.StatusInternalServerError, map[string]string{"error": err.Error()})
		}
	} else if tagFilter == "" && nameFilter != "" {
		nameFilter = "%" + strings.ToLower(nameFilter) + "%"
		if err := db.DB().Where("(LOWER(title) LIKE ? OR LOWER(location) LIKE ?) AND is_pending = false AND deleted_at IS NULL  AND date >= ? ", "%"+strings.ToLower(nameFilter)+"%", "%"+strings.ToLower(nameFilter)+"%", today).Find(&events).Error; err != nil {
			return c.JSON(http.StatusInternalServerError, map[string]string{"error": err.Error()})
		}
	} else {
		if err := db.DB().Where("is_pending = false AND deleted_at IS NULL  AND date >= ?", today).Find(&events).Error; err != nil {
			return c.JSON(http.StatusInternalServerError, map[string]string{"error": err.Error()})
		}
	}

	if len(events) == 0 {
		return c.JSON(http.StatusOK, []SimpleEvent{})
	}

	// Convert events to SimpleEvent
	var simpleEvents []SimpleEvent
	for _, event := range events {
		bannerContent, err := utils.ReadAndEncodeFile("./" + event.Banner)

		if err != nil {
			return echo.NewHTTPError(http.StatusInternalServerError, err)
		}

		imageContent, err := utils.ReadAndEncodeFile("./" + event.Image)

		if err != nil {
			return echo.NewHTTPError(http.StatusInternalServerError, err)
		}

		simpleEvents = append(simpleEvents, SimpleEvent{
			ID:          event.ID,
			Title:       event.Title,
			Description: event.Description,
			Tag:         event.Tag,
			Banner:      bannerContent,
			Image:       imageContent,
			Date:        event.Date,
			Place:       event.Place,
			IsPending:   event.IsPending,
		})
	}

	return c.JSON(http.StatusOK, simpleEvents)
}

// @Summary Get events today
// @Tags Event
// @Accept json
// @Produce json
// @Success 200 {object} interface{} "Event found"
// @Failure 400 {object} error "Bad request"
// @Failure 404 {object} error "Event not found"
// @Failure 500 {object} error "Internal server error"
// @Router /events/today [get]
func GetAllEventsToday(c echo.Context) error {
	var events []models.Event

	currentDate := time.Now().Format("2006-01-02")

	dateStart := currentDate + " 00:00:00"
	dateEnd := currentDate + " 23:59:59"

	if err := db.DB().Where("deleted_at IS NULL  AND is_pending = false AND date BETWEEN ? AND ? ", dateStart, dateEnd).Find(&events).Error; err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{"error": err.Error()})
	}

	if len(events) == 0 {
		return c.JSON(http.StatusOK, []SimpleEvent{})
	}

	var simpleEvents []SimpleEvent
	for _, event := range events {
		bannerContent, err := utils.ReadAndEncodeFile("./" + event.Banner)

		if err != nil {
			return echo.NewHTTPError(http.StatusInternalServerError, err)
		}

		imageContent, err := utils.ReadAndEncodeFile("./" + event.Image)

		if err != nil {
			return echo.NewHTTPError(http.StatusInternalServerError, err)
		}

		simpleEvents = append(simpleEvents, SimpleEvent{
			ID:          event.ID,
			Title:       event.Title,
			Description: event.Description,
			Tag:         event.Tag,
			Banner:      bannerContent,
			Image:       imageContent,
			Date:        event.Date,
			Place:       event.Place,
			IsPending:   event.IsPending,
		})
	}

	return c.JSON(http.StatusOK, simpleEvents)
}

// @Summary Generate a random code to join an event
// @Tags Event
// @Accept json
// @Produce json
// @Param id path string true "Event ID"
// @Success 200 {object} map[string]string "Generated code"
// @Failure 400 {object} error "Bad request"
// @Failure 500 {object} error "Internal server error"
// @Router /event/{id}/code [post]
// func CreateCode(c echo.Context) error {
// 	eventId := c.Param("id")

// 	code := utils.GenerateRandomString(6)

// 	// Save in bdd the invitation code for the event
// 	var event models.Event
// 	if err := db.DB().First(&event, "id = ?", eventId).Error; err != nil {
// 		return err
// 	}

// 	event.Code = code

// 	if err := db.DB().Save(&event).Error; err != nil {
// 		return err
// 	}

// 	return c.JSON(http.StatusOK, map[string]string{"code": code})
// }

// @Summary Join an event using a code
// @Tags Event
// @Accept json
// @Produce json
// @Param code path string true "Invitation code"
// @Success 200 {string} string "Successfully joined the event"
// @Failure 400 {object} error "Bad request"
// @Failure 404 {object} error "Event not found"
// @Failure 500 {object} error "Internal server error"
// @Router /event/join/{code} [post]
func JoinEvent(c echo.Context) error {
	code := c.Param("code")

	claims, err := utils.GetTokenFromHeader(c)
	if err != nil {
		return c.JSON(http.StatusBadRequest, map[string]string{"error": err.Error()})
	}

	userID := claims["id"].(string)

	var event models.Event
	if err := db.DB().First(&event, "code = ?", code).Error; err != nil {
		return c.JSON(http.StatusNotFound, map[string]string{"error": "Event not found"})
	}

	organizerUserID := uuid.MustParse(userID)
	eventID := event.ID

	// Define the association table struct
	type OrganizerEvent struct {
		OrganizerUserID uuid.UUID `gorm:"type:uuid"`
		EventID         uuid.UUID `gorm:"type:uuid"`
	}

	// Create the association
	organizerEvent := OrganizerEvent{
		OrganizerUserID: organizerUserID,
		EventID:         eventID,
	}

	// Check if the user is already joined the event
	var count int64
	if err := db.DB().Table("organizer_events").Where("organizer_user_id = ? AND event_id = ?", organizerUserID, eventID).Count(&count).Error; err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{"error": "Failed to join event"})
	}

	if count > 0 {
		return c.JSON(http.StatusBadRequest, map[string]string{"error": "User already joined the event"})
	}

	// Save the association in the database
	if err := db.DB().Table("organizer_events").Create(&organizerEvent).Error; err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{"error": "Failed to join event"})
	}

	// Clear the invitation code after successful join
	// event.Code = ""
	// if err := db.DB().Save(&event).Error; err != nil {
	// 	return c.JSON(http.StatusInternalServerError, map[string]string{"error": "Failed to update event"})
	// }

	return c.String(http.StatusOK, "Successfully joined the event")
}

// @Summary Get events by organizer
// @Tags Event
// @Accept json
// @Produce json
// @Param id path string true "Organizer ID"
// @Success 200 {object} interface{} "Events found"
// @Failure 400 {object} error "Bad request"
// @Failure 404 {object} error "Events not found"
// @Failure 500 {object} error "Internal server error"
// @Router /events/organizer [get]
func GetEventsByOrganizer(c echo.Context) error {
	claims, err := utils.GetTokenFromHeader(c)
	if err != nil {
		return c.JSON(http.StatusBadRequest, map[string]string{"error": err.Error()})
	}

	userID := claims["id"].(string)

	var events []models.Event

	if err := db.DB().Table("events").Joins("JOIN organizer_events ON events.id = organizer_events.event_id").Where("organizer_events.organizer_user_id = ? AND deleted_at IS NULL", userID).Find(&events).Error; err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{"error": err.Error()})
	}

	if len(events) == 0 {
		return c.JSON(http.StatusOK, []SimpleEvent{})
	}

	var simpleEvents []SimpleEvent
	for _, event := range events {
		bannerContent, err := utils.ReadAndEncodeFile("./" + event.Banner)

		if err != nil {
			return echo.NewHTTPError(http.StatusInternalServerError, err)
		}

		imageContent, err := utils.ReadAndEncodeFile("./" + event.Image)

		if err != nil {
			return echo.NewHTTPError(http.StatusInternalServerError, err)
		}

		simpleEvents = append(simpleEvents, SimpleEvent{
			ID:          event.ID,
			Title:       event.Title,
			Description: event.Description,
			Tag:         event.Tag,
			Banner:      bannerContent,
			Image:       imageContent,
			Date:        event.Date,
			Place:       event.Place,
			IsPending:   event.IsPending,
		})
	}

	return c.JSON(http.StatusOK, simpleEvents)
}

// @Summary Delete an event
// @Tags Event
// @Accept json
// @Produce json
// @Param id path string true "Event ID"
// @Success 200 {string} string "Event deleted successfully!"
// @Failure 400 {object} error "Bad request"
// @Failure 500 {object} error "Internal server error"
// @Router /event/{id} [delete]
func DeleteEvent(c echo.Context) error {
	eventID := c.Param("id")

	claims, err := utils.GetTokenFromHeader(c)
	if err != nil {
		return c.JSON(http.StatusBadRequest, map[string]string{"error": err.Error()})
	}

	userID := claims["id"].(string)

	// if the user is not the organizer of the event, return an error
	var count int64
	if err := db.DB().Table("organizer_events").Where("organizer_user_id = ? AND event_id = ?", userID, eventID).Count(&count).Error; err != nil {
		return err
	}

	if count == 0 {
		return c.JSON(http.StatusBadRequest, map[string]string{"error": "You are not the organizer of this event"})
	}

	var event models.Event
	if err := db.DB().First(&event, "id = ?", eventID).Error; err != nil {
		return err
	}

	currentDate := time.Now()
	event.DeletedAt = &currentDate

	if err := db.DB().Save(&event).Error; err != nil {
		return err
	}

	return c.String(http.StatusOK, "Event deleted successfully!")
}

func GetAllPendingEvents(c echo.Context) error {
	var events []models.Event

	if err := db.DB().Where("is_pending = true").Find(&events).Error; err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{"error": err.Error()})
	}

	if len(events) == 0 {
		return c.JSON(http.StatusOK, []SimpleEvent{})
	}

	var simpleEvents []SimpleEvent
	for _, event := range events {
		bannerContent, err := utils.ReadAndEncodeFile("./" + event.Banner)

		if err != nil {
			return echo.NewHTTPError(http.StatusInternalServerError, err)
		}

		imageContent, err := utils.ReadAndEncodeFile("./" + event.Image)

		if err != nil {
			return echo.NewHTTPError(http.StatusInternalServerError, err)
		}

		simpleEvents = append(simpleEvents, SimpleEvent{
			ID:          event.ID,
			Title:       event.Title,
			Description: event.Description,
			Tag:         event.Tag,
			Banner:      bannerContent,
			Image:       imageContent,
			Date:        event.Date,
			Place:       event.Place,
		})
	}

	return c.JSON(http.StatusOK, simpleEvents)
}

func ValidateEvent(c echo.Context) error {
	eventID := c.Param("id")

	var event models.Event
	if err := db.DB().First(&event, "id = ?", eventID).Error; err != nil {
		return err
	}

	event.IsPending = false

	if err := db.DB().Save(&event).Error; err != nil {
		return err
	}

	return c.String(http.StatusOK, "Event validated successfully!")
}
