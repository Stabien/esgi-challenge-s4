package models

import (
	"github.com/google/uuid"
	"gorm.io/gorm"
)

type Notification struct {
	gorm.Model
	SenderID   uuid.UUID `gorm:"type:uuid"`
	ReceiverID uuid.UUID `gorm:"type:uuid"`
	Sender     User
	Receiver   User
	Content    string
	Type       string
	IsOpened   bool
}
