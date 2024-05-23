package controllers

import (
	"net/http"

	"github.com/labstack/echo/v4"
)

// CreateMessage crée un nouveau message
// @Summary Create a new message
// @Description Create a new message with the given details
// @Tags messages
// @Accept  json
// @Produce  json
// @Success 200 {object} map[string]interface{} "Message created"
// @Failure 400 {object} map[string]interface{} "Bad request"
// @Router /messages [post]
func CreateMessage(c echo.Context) error {
	return c.JSON(http.StatusOK, echo.Map{"message": "Message created"})
}

// GetMessage renvoie un message par ID
// @Summary Get a message by ID
// @Description Retrieve a message by its ID
// @Tags messages
// @Accept  json
// @Produce  json
// @Param id path int true "Message ID"
// @Success 200 {object} map[string]interface{} "Message fetched"
// @Failure 404 {object} map[string]interface{} "Message not found"
// @Router /messages/{id} [get]
func GetMessage(c echo.Context) error {
	return c.JSON(http.StatusOK, echo.Map{"message": "Message fetched"})
}

// UpdateMessage met à jour un message par ID
// @Summary Update a message by ID
// @Description Update a message with the given details by its ID
// @Tags messages
