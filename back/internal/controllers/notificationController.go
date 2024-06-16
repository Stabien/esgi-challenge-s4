package controllers

import (
	"easynight/internal/db"
	"easynight/internal/models"
	"net/http"

	"github.com/google/uuid"
	"github.com/labstack/echo/v4"
)

// NotificationInput représente le payload pour créer une notification
type NotificationInput struct {
	SenderID   uuid.UUID `json:"sender_id"`
	ReceiverID uuid.UUID `json:"receiver_id"`
	Content    string    `json:"content"`
	Type       string    `json:"type"`
	IsOpened   bool      `json:"is_opened"`
}


// CreateNotification crée un nouveau notification
// @Summary Create a new notification
// @Tags notification
// @Accept  json
// @Produce  json
// @Success 200 {object} map[string]interface{} "notification created"
// @Failure 400 {object} map[string]interface{} "Bad request"
// @Router /notifications [post]
func CreateNotification(c echo.Context) error {
	var input NotificationInput
	if err := c.Bind(&input); err != nil {
		return c.JSON(http.StatusBadRequest, err)
	}

	notification := models.Notification{
		SenderID:   input.SenderID,
		ReceiverID: input.ReceiverID,
		Content:    input.Content,
		Type:       input.Type,
		IsOpened:   input.IsOpened,
	}

	if err := db.DB().Create(&notification).Error; err != nil {
		return c.JSON(http.StatusInternalServerError, err)
	}

	return c.JSON(http.StatusCreated, notification)
}

// GetNotification godoc
// @Summary Get a notification by ID
// @Description Get a notification by ID
// @Tags notifications
// @Produce json
// @Param id path string true "Notification ID"
// @Success 200 {object} Notification
// @Router /notifications/{id} [get]
func GetNotification(c echo.Context) error {
	id := c.Param("id")
	var notification models.Notification
	if err := db.DB().First(&notification, "id = ?", id).Error; err != nil {
		return c.JSON(http.StatusNotFound, err)
	}
	return c.JSON(http.StatusOK, notification)
}

// GetAllNotifications godoc
// @Summary Get all notifications
// @Description Get all notifications
// @Tags notifications
// @Produce json
// @Success 200 {array} Notification
// @Router /notifications [get]
func GetAllNotifications(c echo.Context) error {
	var notifications []models.Notification
	if err := db.DB().Find(&notifications).Error; err != nil {
		return c.JSON(http.StatusInternalServerError, err)
	}
	return c.JSON(http.StatusOK, notifications)
}

// UpdateNotification godoc
// @Summary Update a notification by ID
// @Description Update a notification by ID
// @Tags notifications
// @Accept json
// @Produce json
// @Param id path string true "Notification ID"
// @Param notification body NotificationInput true "Notification Input"
// @Success 200 {object} Notification
// @Router /notifications/{id} [put]
func UpdateNotification(c echo.Context) error {
	id := c.Param("id")
	var notification models.Notification
	if err := db.DB().First(&notification, "id = ?", id).Error; err != nil {
		return c.JSON(http.StatusNotFound, err)
	}

	var input NotificationInput
	if err := c.Bind(&input); err != nil {
		return c.JSON(http.StatusBadRequest, err)
	}

	notification.SenderID = input.SenderID
	notification.ReceiverID = input.ReceiverID
	notification.Content = input.Content
	notification.Type = input.Type
	notification.IsOpened = input.IsOpened

	if err := db.DB().Save(&notification).Error; err != nil {
		return c.JSON(http.StatusInternalServerError, err)
	}

	return c.JSON(http.StatusOK, notification)
}

// DeleteNotification godoc
// @Summary Delete a notification by ID
// @Description Delete a notification by ID
// @Tags notifications
// @Produce json
// @Param id path string true "Notification ID"
// @Success 204
// @Router /notifications/{id} [delete]
func DeleteNotification(c echo.Context) error {
	id := c.Param("id")
	if err := db.DB().Delete(&models.Notification{}, "id = ?", id).Error; err != nil {
		return c.JSON(http.StatusInternalServerError, err)
	}
	return c.NoContent(http.StatusNoContent)
}