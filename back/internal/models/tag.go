package models

import (
	"github.com/google/uuid"
	"gorm.io/gorm"
)

type Tag struct {
	gorm.Model
	ID   uuid.UUID `gorm:"primaryKey;type:uuid;default:uuid_generate_v4();unique"`
	Name string    `gorm:"type:varchar(255);not null"`
}
