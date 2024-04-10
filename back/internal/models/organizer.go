package models

import (
	"github.com/google/uuid"
)

type Organizer struct {
	UserID    uuid.UUID `gorm:"type:uuid;ForeignKey:ID"`
	User      User      `gorm:"foreignKey:UserID"`
	Firstname string
	Lastname  string
}
