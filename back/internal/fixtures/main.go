package fixtures

import (
	"log"

	"gorm.io/gorm"
)

var AllFixtures = []any{
	Users,
	Admins,
	Organizers,
	Customers,
	Events,
	Reservations,
	Features,
	Tags,
}

func LoadFixtures(db *gorm.DB) {
	for _, fixture := range AllFixtures {
		result := db.Create(fixture)

		if result.Error != nil {
			log.Fatal(result.Error)
		}
	}
}
