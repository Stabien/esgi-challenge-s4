package models

import (
	"github.com/google/uuid"
	"gorm.io/gorm"
)

type Admin struct {
	gorm.Model
	UserID uuid.UUID
	User   User
}
