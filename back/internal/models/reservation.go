package models

import (
	"github.com/google/uuid"
	"gorm.io/gorm"
)

type Reservation struct {
	gorm.Model
	ID         uuid.UUID `gorm:"primaryKey;type:uuid;default:uuid_generate_v4()"`
	CustomerID uuid.UUID `gorm:"type:uuid"`
	Customer   Customer  `gorm:"references:UserID"`
	EventID    uuid.UUID `gorm:"type:uuid"`
	Event      Event
	Qrcode     string
	IsScanned  bool `gorm:"default:false"`
}
