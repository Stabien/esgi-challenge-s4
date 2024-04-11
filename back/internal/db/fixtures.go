package db

import (
	"easynight/internal/db/fixtures"

	"gorm.io/gorm"
)

func InitFixtures(db *gorm.DB) {
	db.Create(&fixtures.BaseUsers)
}
