package models

import (
	"database/sql"
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

type Event struct {
	gorm.Model
	ID                uuid.UUID     `gorm:"primaryKey;type:uuid;default:uuid_generate_v4()"`
	Reservations      []Reservation `gorm:"foreignKey:EventID"`
	Messages          []Message     `gorm:"foreignKey:EventID"`
	Rates             []Rate        `gorm:"foreignKey:EventID"`
	OrganizerID       uuid.UUID     `gorm:"type:uuid"`
	Organizer         Organizer     `gorm:"references:UserID"`
	Title             string
	Description       string
	Banner            string
	Photo             sql.NullString
	Date              time.Time
	ParticipantNumber *int
	Lat               float32
	Lng               float32
	Location          string
	Place             string
	Tag               string
}
