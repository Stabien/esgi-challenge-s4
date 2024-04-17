package db

import (
	"easynight/internal/db/fixtures"
	"log"

	"gorm.io/gorm"
)

func InitFixtures(db *gorm.DB) {
	for _, fixture := range fixtures.AllFixtures {
		result := db.Create(fixture)

		if (result.Error != nil) {
			log.Fatal(result.Error)
		}
	}
}
