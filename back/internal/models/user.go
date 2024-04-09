package models

type User struct {
	ID uuid.UUID `gorm:"type:uuid;default:uuid_generate_v4()"`
	Email string
	Password string
}