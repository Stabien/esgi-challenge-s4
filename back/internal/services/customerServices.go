package services

import (
	"easynight/internal/db"
	"easynight/internal/models"
)

func GetCustomerByID(id string) models.Customer {
	var customer models.Customer

	query := map[string]interface{}{
		"customerId": id,
	}

	db := db.DB()
	db.Where(query).Find(&customer)

	return customer
}
