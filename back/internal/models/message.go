package models

import (
	"github.com/google/uuid"
	"gorm.io/gorm"
)

type Message struct {
	gorm.Model
	EventID     uuid.UUID `gorm:"type:uuid"`
	Event       Event
	OrganizerID uuid.UUID `gorm:"type:uuid"`
	Organizer   Organizer
	Content     string
}
