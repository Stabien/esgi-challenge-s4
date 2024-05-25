package controllers

import (
	"net/http"
	"strings"
	"time"

	"easynight/internal/db"
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
	// Define EventInput struct
	var eventInput EventInput

	// Bind request body to EventInput struct
	if err := c.Bind(&eventInput); err != nil {
		return err
	}

	date, err := time.Parse("2006-01-02", eventInput.Date)
	if err != nil {
		// handle error
		return err
	}

	// Create new event object
	event := models.Event{
		Title:             eventInput.Title,
		Description:       eventInput.Description,
		Banner:            eventInput.Banner,
		Image:             eventInput.Image,
		Date:              date,
		ParticipantNumber: eventInput.ParticipantNumber,
		Lat:               float32(eventInput.Lat),
		Lng:               float32(eventInput.Lng),
		Location:          eventInput.Location,
		Tag:               eventInput.Tag,
		Place:             eventInput.Place,
		Code:              utils.GenerateRandomString(6),
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

// @Summary Update an existing event
// @Tags Event
// @Accept json
// @Produce json
// @Param id path string true "Event ID"
// @Param event body EventInput true "Event input"
// @Success 200 {string} string "Event updated successfully!"
// @Failure 400 {object} error "Bad request"
// @Failure 500 {object} error "Internal server error"
// @Router /event/{id} [patch]
func UpdateEvent(c echo.Context) error {
	// Get event ID from URL
	eventID := c.Param("id")

	// Define EventInput struct
	var updateInput EventInput

	// Bind request body to EventInput struct
	if err := c.Bind(&updateInput); err != nil {
		return err
	}

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

	// Update event fields
	event.Title = updateInput.Title
	event.Description = updateInput.Description
	event.Banner = updateInput.Banner
	event.Image = updateInput.Image
	event.Location = updateInput.Location
	event.ParticipantNumber = updateInput.ParticipantNumber
	event.Lat = float32(updateInput.Lat)
	event.Lng = float32(updateInput.Lng)
	event.Tag = updateInput.Tag
	event.Place = updateInput.Place

	if err := db.DB().Model(&event).Updates(&event).Error; err != nil {
		return err
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

	// Map fields from Event to EventDetails
	eventDetails := EventDetails{
		ID:                event.ID,
		Title:             event.Title,
		Description:       event.Description,
		Tag:               event.Tag,
		Banner:            event.Banner,
		Image:             event.Image,
		Date:              event.Date,
		Place:             event.Place,
		Lat:               event.Lat,
		Lng:               event.Lng,
		Location:          event.Location,
		ParticipantNumber: event.ParticipantNumber,
		PlaceRestante:     *event.ParticipantNumber - int(count),
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

	if tagFilter != "" && nameFilter != "" {
		if err := db.DB().Where("LOWER(title) LIKE ? AND tag = ?", "%"+strings.ToLower(nameFilter)+"%", tagFilter).Find(&events).Error; err != nil {
			return c.JSON(http.StatusInternalServerError, map[string]string{"error": err.Error()})
		}
	} else if tagFilter != "" && nameFilter == "" {
		if err := db.DB().Where("tag = ?", tagFilter).Find(&events).Error; err != nil {
			return c.JSON(http.StatusInternalServerError, map[string]string{"error": err.Error()})
		}
	} else if tagFilter == "" && nameFilter != "" {
		nameFilter = "%" + strings.ToLower(nameFilter) + "%"
		if err := db.DB().Where("LOWER(title) LIKE ?", nameFilter).Find(&events).Error; err != nil {
			return c.JSON(http.StatusInternalServerError, map[string]string{"error": err.Error()})
		}
	} else {
		if err := db.DB().Find(&events).Error; err != nil {
			return c.JSON(http.StatusInternalServerError, map[string]string{"error": err.Error()})
		}
	}

	if len(events) == 0 {
		return c.JSON(http.StatusOK, []SimpleEvent{})
	}

	// Convert events to SimpleEvent
	var simpleEvents []SimpleEvent
	for _, event := range events {
		simpleEvents = append(simpleEvents, SimpleEvent{
			ID:          event.ID,
			Title:       event.Title,
			Description: event.Description,
			Tag:         event.Tag,
			Banner:      event.Banner,
			Image:       event.Image,
			Date:        event.Date,
			Place:       event.Place,
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

	if err := db.DB().Where("date BETWEEN ? AND ?", dateStart, dateEnd).Find(&events).Error; err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{"error": err.Error()})
	}

	if len(events) == 0 {
		return c.JSON(http.StatusOK, []SimpleEvent{})
	}

	var simpleEvents []SimpleEvent
	for _, event := range events {
		simpleEvents = append(simpleEvents, SimpleEvent{
			ID:          event.ID,
			Title:       event.Title,
			Description: event.Description,
			Tag:         event.Tag,
			Banner:      event.Banner,
			Image:       event.Image,
			Date:        event.Date,
			Place:       event.Place,
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
// @Router /events/organizer/{id} [get]
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
		simpleEvents = append(simpleEvents, SimpleEvent{
			ID:          event.ID,
			Title:       event.Title,
			Description: event.Description,
			Tag:         event.Tag,
			Banner:      event.Banner,
			Image:       event.Image,
			Date:        event.Date,
			Place:       event.Place,
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
