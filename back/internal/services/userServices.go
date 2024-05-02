package services

import (
	"easynight/internal/db"
	"easynight/internal/models"
)

func CreateUser(user models.User) (models.User, error) {
	return CreateEntity(user)
}

func CreateCustomer(customer models.Customer) (models.Customer, error) {
	return CreateEntity(customer)
}

func CreateOrganizer(organizer models.Organizer) (models.Organizer, error) {
	return CreateEntity(organizer)
}

func GetUserByID(id int) models.User {
	var user models.User

	query := map[string]interface{}{
		"id": id,
	}

	db := db.DB()
	db.Where(query).Find(&user)

	return user
}

func GetUserByEmail(email string) models.User {
	var user models.User

	query := map[string]interface{}{
		"email": email,
	}

	db := db.DB()
	db.Where(query).Find(&user)

	return user
}
