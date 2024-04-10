package models

import (
	"github.com/google/uuid"
)

type Admin struct {
	UserID uuid.UUID `gorm:"type:uuid;ForeignKey:ID"`
	User   User `gorm:"foreignKey:UserID"`
}