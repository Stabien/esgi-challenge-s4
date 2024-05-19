package controllers

import (
	"easynight/internal/db"
	"easynight/internal/models"

	// "encoding/json"

	"net/http"

	"github.com/google/uuid"
	"github.com/labstack/echo/v4"
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

	// Convert events to SimpleEvent
	var simpleEvents []SimpleEvent
	for _, event := range events {
		simpleEvents = append(simpleEvents, SimpleEvent{
			ID:          event.ID,
			Title:       event.Title,
			Description: event.Description,
			Tag:         event.Tag,
			Banner:      event.Banner,
			Image:       event.Image,
			Date:        event.Date,
			Place:       event.Place,
		})
	}

	return c.JSON(http.StatusOK, simpleEvents)

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
// func IsReserv(c echo.Context) error {
// 	customerID := c.Param("customerId")
// 	eventID := c.Param("eventId")

// 	var reservation []models.Reservation
// 	if err := db.DB().Where("customer_id = ? AND event_id = ?", customerID, eventID).Find(&reservation).Error; err != nil {
// 		// Une erreur interne s'est produite
// 		return c.JSON(http.StatusInternalServerError, map[string]string{"error": err.Error()})
// 	}

// 	// Si aucune réservation n'est trouvée, retourner un tableau vide
// 	if len(reservation) == 0 {
// 		return c.JSON(http.StatusOK, []SimpleReservation{})
// 	}

// 	var simpleReservation []SimpleReservation
// 	for _, reservation := range reservations {
// 		simpleReservation = append(simpleReservation, simpleReservation{
// 			ID: reservation.ID,
// 		})
// 	}

// 	return c.JSON(http.StatusOK, simpleReservation)
// }
