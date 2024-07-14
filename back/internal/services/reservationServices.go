package services

import (
	"easynight/internal/db"
	"easynight/internal/models"
)

func GetReservationByCustomerID(id string) models.Reservation {
	var reservation models.Reservation

	query := map[string]interface{}{
		"customerId": id,
	}

	db := db.DB()
	db.Where(query).Find(&reservation)

	return reservation
}
