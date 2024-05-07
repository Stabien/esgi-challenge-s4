package controllers

import (
	"easynight/internal/db"
	"easynight/internal/models"

	// "encoding/json"

	"net/http"

	"github.com/labstack/echo/v4"
	_ "gorm.io/gorm"
)

// @Summary add reservation
// @Tags Reservation
// @Accept json
// @Produce json
// @Param body body models.Reservation true "Reservation object"
// @Success 201 {object} models.Reservation "Successfully created"
// @Failure 400 {object} error "Bad request"
// @Failure 500 {object} error "Internal server error"
// @Router /reservations [post]
func PostReservation(c echo.Context) error {
	var reservationRequest models.Reservation

	if err := c.Bind(&reservationRequest); err != nil {
		return echo.NewHTTPError(http.StatusBadRequest, "Invalid request body")
	}

	reservation := models.Reservation{
		CustomerID: reservationRequest.CustomerID,
		EventID:    reservationRequest.EventID,
	}

	if err := db.DB().Create(&reservation).Error; err != nil {
		return echo.NewHTTPError(http.StatusInternalServerError, err.Error())
	}

	return c.JSON(http.StatusCreated, reservation)
}

// @Summary delete reservation
// @Tags Reservation
// @Accept json
// @Produce json
// @Param body body models.Reservation true "Reservation request object"
// @Success 204 "Successfully deleted"
// @Failure 400 {object} error "Bad request"
// @Failure 500 {object} error "Internal server error"
// @Router /reservations [delete]
func DeleteReservation(c echo.Context) error {
	var reservationRequest models.Reservation

	if err := c.Bind(&reservationRequest); err != nil {
		return echo.NewHTTPError(http.StatusBadRequest, "Invalid request body")
	}

	// Suppose you have a function to find and delete the reservation based on event and customer IDs.
	if err := db.DB().Where("event_id = ? AND customer_id = ?", reservationRequest.EventID, reservationRequest.CustomerID).Delete(&models.Reservation{}).Error; err != nil {
		return echo.NewHTTPError(http.StatusInternalServerError, err.Error())
	}

	return c.NoContent(http.StatusNoContent)
}

// @Summary get reservation by user
// @Tags Reservation
// @Accept json
// @Produce json
// @Param customerId path string true "customerId"
// @Success 204 "Successfully get"
// @Failure 400 {object} error "Bad request"
// @Failure 500 {object} error "Internal server error"
// @Router /reservations/{customerId} [get]
func GetReservationsbyUser(c echo.Context) error {
	CustomerID := c.Param("customerId")

	var events []models.Event

	// Join reservations table with events table and filter by customer ID
	if err := db.DB().Joins("JOIN reservations ON events.id = reservations.event_id").
		Where("reservations.customer_id = ?", CustomerID).
		Find(&events).Error; err != nil {
		return echo.NewHTTPError(http.StatusInternalServerError, err.Error())
	}

	return c.JSON(http.StatusOK, events)
}
