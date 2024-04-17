package models

import (
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

type Organizer struct {
	UserID    uuid.UUID `gorm:"primaryKey;type:uuid"`
	User      User
	Firstname string
	Lastname  string
	Events    []Event   `gorm:"foreignKey:OrganizerID"`
	Messages  []Message `gorm:"foreignKey:OrganizerID"`
	CreatedAt time.Time
	UpdatedAt time.Time
	DeletedAt gorm.DeletedAt `gorm:"index"`
}
