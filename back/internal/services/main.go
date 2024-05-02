package services

import (
	"easynight/internal/db"
)

func CreateEntity[T any](user T) (T, error) {
	db := db.DB()
	result := db.Create(&user)

	return user, result.Error
}
