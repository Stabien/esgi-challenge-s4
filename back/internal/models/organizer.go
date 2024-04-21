package models

import (
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

type Organizer struct {
	UserID    uuid.UUID `gorm:"primaryKey;type:uuid;unique"`
	User      User
	Firstname string
	Lastname  string
	Messages  []Message `gorm:"foreignKey:OrganizerID"`
	CreatedAt time.Time
	UpdatedAt time.Time
	DeletedAt gorm.DeletedAt `gorm:"index"`
}
