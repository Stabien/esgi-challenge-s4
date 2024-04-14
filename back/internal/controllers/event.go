package controllers

import (
	"net/http"
	"time"

	"easynight/internal/db"
	"easynight/internal/models"

	"github.com/labstack/echo/v4"
)

type EventInput struct {
	Title             string  `json:"title"`
	Description       string  `json:"description"`
	Banner            string  `json:"banner"`
	Date              string  `json:"date"`
	ParticipantNumber int     `json:"participant_number"`
	Lat               float64 `json:"lat"`
	Lng               float64 `json:"lng"`
	Location          string  `json:"location"`
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
		Date:              date,
		ParticipantNumber: eventInput.ParticipantNumber,
		Lat:               float32(eventInput.Lat),
		Lng:               float32(eventInput.Lng),
		Location:          eventInput.Location,
		// Tag:            "", // TODO: Add tag
	}

	// Insert event into database
	if err := db.DB().Create(&event).Error; err != nil {
		return err
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
	event.Location = updateInput.Location
	event.ParticipantNumber = updateInput.ParticipantNumber
	event.Lat = float32(updateInput.Lat)
	event.Lng = float32(updateInput.Lng)

	// Save event to database
	if err := db.DB().Save(&event).Error; err != nil {
		return err
	}

	return c.String(http.StatusOK, "Event updated successfully!")
}
