package controllers

import (
	"log"
	"net/http"
	"strings"
	"time"

	"easynight/internal/db"
	"easynight/internal/models"

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
}

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
	}

	// Insert event into database
	if err := db.DB().Create(&event).Error; err != nil {
		return err
	} else {
		log.Println("New event: ", eventInput)
	}

	// Return success message
	return c.String(http.StatusOK, "Event created successfully!")
}

func UpdateEvent(c echo.Context) error {
	// Get event ID from URL
	eventID := c.Param("id")

	// Define EventInput struct
	var updateInput EventInput

	// Bind request body to EventInput struct
	if err := c.Bind(&updateInput); err != nil {
		return err
	}

	// Get event from database
	var event models.Event
	if err := db.DB().First(&event, "id = ?", eventID).Error; err != nil {
		return err
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

	// Save event to database
	if err := db.DB().Save(&event).Error; err != nil {
		return err
	} else {
		log.Println("Event updated: ", event)
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
