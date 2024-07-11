package models

import (
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

type Message struct {
	gorm.Model
	ID          uuid.UUID `gorm:"primaryKey;type:uuid;default:uuid_generate_v4()"`
	EventID     uuid.UUID `gorm:"type:uuid"`
	Event       Event
	OrganizerID uuid.UUID `gorm:"type:uuid"`
	Organizer   Organizer
	Text        string
	Sender      string
	Date        time.Time `gorm:"type:timestamp"`
}
