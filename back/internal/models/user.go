package models

import (
	"github.com/google/uuid"
)

type User struct {
	ID uuid.UUID `gorm:"primaryKey;type:uuid;default:uuid_generate_v4()"`
	Email string
	Password string
}