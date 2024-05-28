package models

import (
	"github.com/google/uuid"
	"gorm.io/gorm"
)

type User struct {
	gorm.Model
	ID                   uuid.UUID      `gorm:"primaryKey;type:uuid;default:uuid_generate_v4();unique"`
	Admins               []Admin        `gorm:"foreignKey:UserID"`
	Customers            []Customer     `gorm:"foreignKey:UserID"`
	Organizers           []Organizer    `gorm:"foreignKey:UserID"`
	Rates                []Rate         `gorm:"foreignKey:UserID"`
	NotificationSent     []Notification `gorm:"foreignKey:SenderID"`
	NotificationReceived []Notification `gorm:"foreignKey:ReceiverID"`
	Email                string
	Password             string
	Role                 string
}
