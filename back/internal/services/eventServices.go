package services

import (
	"easynight/internal/db"
	"easynight/internal/models"

	"github.com/google/uuid"
)

func ContainsOrganizerId(organizers []models.Organizer, organizerId uuid.UUID) bool {
	for _, organizer := range organizers {
		if organizer.UserID == organizerId {
			return true
		}
	}
	return false
}

func DoesOrganizerBelongsToEvent(eventId uuid.UUID, organizerId uuid.UUID) bool {
	var event models.Event

	query := map[string]interface{}{
		"id": eventId,
	}

	db := db.DB()
	db.Preload("Organizers").Where(query).Find(&event)

	return ContainsOrganizerId(event.Organizers, organizerId)
}

func GetEventById(eventId uuid.UUID) models.Event {
	var event models.Event

	query := map[string]interface{}{
		"id": eventId,
	}

	db := db.DB()
	db.Where(query).Find(&event)

	return event
}
