package models

import (
	"github.com/google/uuid"
	"gorm.io/gorm"
)

type Customer struct {
	gorm.Model
	UserID    uuid.UUID
	User      User
	Firstname string
	Lastname  string
}
