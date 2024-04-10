package models

import (
	"github.com/google/uuid"
	"gorm.io/gorm"
)

type Reservation struct {
	gorm.Model
	ID      uuid.UUID `gorm:"primaryKey;type:uuid;default:uuid_generate_v4()"`
	UserID  uuid.UUID `gorm:"type:uuid"`
	User    User
	EventID uuid.UUID `gorm:"type:uuid"`
	Event   Event
	Name    string
	Qrcode  string
}
