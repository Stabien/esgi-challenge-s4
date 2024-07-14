package services

import (
	"easynight/internal/db"
	"easynight/internal/models"
)

func GetMessageByID(id string) models.Message {
	var message models.Message

	query := map[string]interface{}{
		"id": id,
	}

	db := db.DB()
	db.Where(query).Find(&message)

	return message
}
