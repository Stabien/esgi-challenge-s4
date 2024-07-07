package models

import (
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

type Organizer struct {
	ID        uuid.UUID      `gorm:"type:uuid;default:uuid_generate_v4();primaryKey"`
	UserID    uuid.UUID      `gorm:"type:uuid;unique;not null"`
	User      User           `gorm:"foreignKey:UserID"`
	Firstname string         `gorm:"size:100;not null"`
	Lastname  string         `gorm:"size:100;not null"`
	Messages  []Message      `gorm:"foreignKey:OrganizerID"`
	CreatedAt time.Time      `gorm:"autoCreateTime"`
	UpdatedAt time.Time      `gorm:"autoUpdateTime"`
	DeletedAt gorm.DeletedAt `gorm:"index"`
}
