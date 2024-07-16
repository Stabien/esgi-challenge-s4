package controllers

import (
	"net/http"

	"easynight/internal/firebase"

	"github.com/labstack/echo/v4"
)

// @Summary Send a notification using Firebase Cloud Messaging
// @Tags Notification
// @Accept json
// @Produce json
// @Success 200 {string} string "Notification sent successfully"
// @Failure 400 {object} error "Bad request"
// @Failure 500 {object} error "Internal server error"
// @Router /send-notification [post]
func SendNotificationToTopic(c echo.Context) error {
	// Send notification to specific topic
	err := firebase.SendNotificationToTopic()
	if err != nil {
		return c.String(http.StatusInternalServerError, err.Error())
	}

	return c.String(http.StatusOK, "Notification sent successfully")
}
