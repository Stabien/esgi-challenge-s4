package models

import (
	"github.com/google/uuid"
	"gorm.io/gorm"
)

type EventPhoto struct {
	gorm.Model
	EventID uuid.UUID `gorm:"type:uuid"`
	Event   Event
	Url     string
}
