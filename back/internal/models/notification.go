package models

import (
	"github.com/google/uuid"
	"gorm.io/gorm"
)

type Notification struct {
	gorm.Model
	ID         uuid.UUID `gorm:"primaryKey;type:uuid;default:uuid_generate_v4()"`
	SenderID   uuid.UUID `gorm:"type:uuid"`
	ReceiverID uuid.UUID `gorm:"type:uuid"`
	Sender     User
	Receiver   User
	Content    string
	Type       string
	IsOpened   bool
}
