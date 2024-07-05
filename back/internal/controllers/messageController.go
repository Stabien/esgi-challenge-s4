package controllers

import (
	"easynight/internal/db"
	"easynight/internal/models"
	"net/http"

	"github.com/google/uuid"
	"github.com/labstack/echo/v4"
)

type MessageInput struct {
	EventID     uuid.UUID `json:"eventId"`
	OrganizerID uuid.UUID `json:"organizerId"`
	Content     string    `json:"content"`
}

// CreateMessage creates a new message
// @Summary Create a new message
// @Description Create a new message with the provided data
// @Tags messages
// @Accept json
// @Produce json
// @Param message body MessageInput true "Message data"
// @Success 201 {object} models.Message
// @Router /messages [post]
func CreateMessage(c echo.Context) error {

	var input MessageInput
	if err := c.Bind(&input); err != nil {
		return err
	}

	message := models.Message{
		EventID:     input.EventID,
		OrganizerID: input.OrganizerID,
		Content:     input.Content,
	}

	if err := db.DB().Create(&message).Error; err != nil {
		return err
	}

	return c.JSON(http.StatusCreated, message)
}

// GetMessageByID retrieves a message by ID
// @Summary Get a message by ID
// @Description Retrieve a message based on its unique ID
// @Tags messages
// @Produce json
// @Param id path string true "Message ID"
// @Success 200 {object} models.Message
// @Router /messages/{id} [get]
func GetMessage(c echo.Context) error {

	id, err := uuid.Parse(c.Param("id"))
	if err != nil {
		return err
	}

	var message models.Message
	if err := db.DB().First(&message, "id = ?", id).Error; err != nil {
		return err
	}

	return c.JSON(http.StatusOK, message)
}

// GetAllRates godoc
// @Summary Get all rates
// @Description Get all rates
// @Tags rates
// @Produce json
// @Success 200 {array} models.Rate
// @Router /rates [get]
func GetAllMessage(c echo.Context) error {
	var rates []models.Rate
	if err := db.DB().Find(&rates).Error; err != nil {
		return c.JSON(http.StatusInternalServerError, err)
	}
	return c.JSON(http.StatusOK, rates)
}

// UpdateMessageByID updates a message by ID
// @Summary Update a message by ID
// @Description Update an existing message identified by its ID
// @Tags messages
// @Accept json
// @Produce json
// @Param id path string true "Message ID"
// @Param message body MessageInput true "Updated message data"
// @Success 200 {object} models.Message
// @Router /messages/{id} [put]
func UpdateMessage(c echo.Context) error {

	id, err := uuid.Parse(c.Param("id"))
	if err != nil {
		return err
	}

	var message models.Message
	if err := db.DB().First(&message, "id = ?", id).Error; err != nil {
		return err
	}

	var input MessageInput
	if err := c.Bind(&input); err != nil {
		return err
	}

	message.EventID = input.EventID
	message.OrganizerID = input.OrganizerID
	message.Content = input.Content

	if err := db.DB().Save(&message).Error; err != nil {
		return err
	}

	return c.JSON(http.StatusOK, message)
}

// DeleteMessageByID deletes a message by ID
// @Summary Delete a message by ID
// @Description Delete an existing message identified by its ID
// @Tags messages
// @Param id path string true "Message ID"
// @Success 204 "No Content"
// @Router /messages/{id} [delete]
func DeleteMessage(c echo.Context) error {

	id, err := uuid.Parse(c.Param("id"))
	if err != nil {
		return err
	}

	var message models.Message
	if err := db.DB().First(&message, "id = ?", id).Error; err != nil {
		return err
	}

	if err := db.DB().Delete(&message).Error; err != nil {
		return err
	}

	return c.NoContent(http.StatusNoContent)
}
