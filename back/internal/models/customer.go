package models

import (
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

type Customer struct {
	UserID       uuid.UUID `gorm:"primaryKey;type:uuid"`
	User         User
	Reservations []Reservation `gorm:"foreignKey:CustomerID"`
	Firstname    string
	Lastname     string
	CreatedAt    time.Time
	UpdatedAt    time.Time
	DeletedAt    gorm.DeletedAt `gorm:"index"`
}
