package controllers

import (
	"easynight/internal/db"
	"easynight/internal/models"
	"time"

	// "encoding/json"

	"net/http"

	"github.com/google/uuid"
	"github.com/labstack/echo/v4"
	"gorm.io/gorm"
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
	// {
	// 	"eventID": "7ae9dcae-08b4-4cee-aa60-5bfde44b6b1e",
	// 	"customerID":"3e8aa051-4321-49a0-8bc1-f697585756a4"
	//    }
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

type UserReservation struct {
	ID uuid.UUID `json:"id"`
	CustomerID uuid.UUID `json:"customer_id"`
	Qrcode     string
	Event SimpleEvent 
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

	var reservations []models.Reservation

	err := db.DB().Preload("Customer").Preload("Event").Where("reservations.customer_id = ? AND reservations.deleted_at IS NULL", CustomerID).Find(&reservations).Error;

	if err != nil {
		return echo.NewHTTPError(http.StatusInternalServerError, err.Error());
	}

	if len(reservations) == 0 {
		return c.JSON(http.StatusOK, []UserReservation{})
	}
	var userReservations []UserReservation

	for _, reservation := range reservations {
		var reservationEvent SimpleEvent = SimpleEvent{
			ID:          reservation.Event.ID,
			Title:       reservation.Event.Title,
			Description: reservation.Event.Description,
			Tag:         reservation.Event.Tag,
			Banner:      reservation.Event.Banner,
			Image:       reservation.Event.Image,
			Date:        reservation.Event.Date,
			Place:       reservation.Event.Place,
		}
		userReservations = append(userReservations, UserReservation{
			Event: reservationEvent,
			ID: reservation.ID,
			CustomerID: reservation.CustomerID,
			Qrcode: reservation.Qrcode,
		})
	}
	return c.JSON(http.StatusOK, userReservations)

}

type SimpleReservation struct {
	ID uuid.UUID `json:"id"`
}

// @Summary get reservation by user
// @Tags Reservation
// @Accept json
// @Produce json
// @Param customerId path string true "customerId"
// @Param eventId path string true "eventId"
// @Success 204 "Successfully get"
// @Failure 400 {object} error "Bad request"
// @Failure 500 {object} error "Internal server error"
// @Router /reservations/isreserv/{customerId}/{eventId} [get]
func IsReserv(c echo.Context) error {
	customerID := c.Param("customerId")
	eventID := c.Param("eventId")

	var reservations []models.Reservation
	if err := db.DB().Where("customer_id = ? AND event_id = ?", customerID, eventID).Find(&reservations).Error; err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{"error": err.Error()})
	}

	if len(reservations) == 0 {
		return c.JSON(http.StatusOK, []SimpleReservation{})
	}

	var simpleReservation []SimpleReservation
	for _, reservation := range reservations {
		simpleReservation = append(simpleReservation, SimpleReservation{
			ID: reservation.ID,
		})
	}

	return c.JSON(http.StatusOK, simpleReservation)
}

// @Summary get reservation validity
// @Tags Reservation
// @Accept json
// @Produce json
// @Param reservationId path string true "reservationId"
// @Success 204 "Successfully get"
// @Failure 400 {object} error "Bad request"
// @Failure 500 {object} error "Internal server error"
// @Router /reservations/isValid/{reservationId} [get]
func IsValid(c echo.Context) error {
	reservationId := c.Param("reservationId")

	var reservation models.Reservation

	if err := db.DB().Preload("Event").Where("id = ? AND deleted_at IS NULL", reservationId).First(&reservation).Error; err != nil {
		if err == gorm.ErrRecordNotFound {
			return c.JSON(http.StatusNotFound, map[string]string{"error": "Reservation not found or already deleted"})
		}
		return c.JSON(http.StatusInternalServerError, map[string]string{"error": err.Error()})
	}

	if reservation.Event.Date.After(time.Now()) {
		return c.JSON(http.StatusOK, map[string]bool{"isValid": true})
	} else {
		return c.JSON(http.StatusOK, map[string]interface{}{"isValid": false, "message": "The event is in the past"})
	}


	// if err := db.DB().Preload("Event").Where("reservations.id = ? AND reservations.deleted_at IS NULL",  reservationId).First(&reservation).Error; err != nil {
	// 	return c.JSON(http.StatusInternalServerError, map[string]string{"error": err.Error()})
	// }


	// return c.JSON(http.StatusOK, true)
}
