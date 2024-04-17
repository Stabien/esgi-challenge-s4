package models

import (
	"github.com/google/uuid"
	"gorm.io/gorm"
)

type Admin struct {
	gorm.Model
	UserID uuid.UUID `gorm:"type:uuid"`
	User   User
}
