package db

import (
	"easynight/internal/db/fixtures"
	"fmt"
	"log"

	"gorm.io/gorm"
)

func InitFixtures(db *gorm.DB) {
	for _, fixture := range fixtures.AllFixtures {
		fmt.Print(fixture, '\n')
		result := db.Create(fixture)

		if result.Error != nil {
			log.Fatal(result.Error)
		}
	}
}
