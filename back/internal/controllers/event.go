package controllers

import (
	"encoding/json"
	"net/http"
	"strings"
	"time"

	"easynight/internal/db"
	"easynight/internal/models"

	"github.com/labstack/echo/v4"
)

type EventInput struct {
	Title             string  `json:"title"`
	Description       string  `json:"description"`
	Banner            string  `json:"banner"`
	Image             string  `json:"image"`
	Date              string  `json:"date"`
	ParticipantNumber int     `json:"participant_number"`
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
	}

	return c.String(http.StatusOK, "Event updated successfully!")
}

func GetEvent(c echo.Context) error {
	// Get event ID from URL
	eventID := c.Param("id")

	// Get event from database
	var event models.Event
	if err := db.DB().First(&event, "id = ?", eventID).Error; err != nil {
		return err
	}

	// Return event as JSON response
	return c.JSON(http.StatusOK, event)
}

func GetAllEvents(w http.ResponseWriter, r *http.Request) {
	var events []models.Event
	var nameFilter string = ""

	nameFilter = r.URL.Path[len("/events/"):]

	if nameFilter != "undefined" {
		nameFilter = "%" + strings.ToLower(nameFilter) + "%"
		if err := db.DB().Where("LOWER(title) LIKE ?", nameFilter).Find(&events).Error; err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
	} else {
		if err := db.DB().Find(&events).Error; err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
	}

	w.Header().Set("Content-Type", "application/json")
	if err := json.NewEncoder(w).Encode(events); err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
}
