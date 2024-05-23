package controllers

import (
	"net/http"

	"github.com/labstack/echo/v4"
)

// CreateChat crée un nouveau chat
// @Summary Create a new chat
// @Description Create a new chat with the given details
// @Tags chat
// @Accept  json
// @Produce  json
// @Success 200 {object} map[string]interface{} "Chat created"
// @Failure 400 {object} map[string]interface{} "Bad request"
// @Router /chats [post]
func CreateChat(c echo.Context) error {
	return c.JSON(http.StatusOK, echo.Map{"message": "Chat created"})
}

// GetChat renvoie un chat par ID
// @Summary Get a chat by ID
// @Description Retrieve a chat by its ID
// @Tags chat
// @Accept  json
// @Produce  json
// @Param id path int true "Chat ID"
// @Success 200 {object} map[string]interface{} "Chat fetched"
// @Failure 404 {object} map[string]interface{} "Chat not found"
// @Router /chats/{id} [get]
func GetChat(c echo.Context) error {
	return c.JSON(http.StatusOK, echo.Map{"message": "Chat fetched"})
}

// UpdateChat met à jour un chat par ID
// @Summary Update a chat by ID
// @Description Update a chat with the given details by its ID
// @Tags chat
// @Accept  json
// @Produce  json
// @Param id path int true "Chat ID"
// @Success 200 {object} map[string]interface{} "Chat updated"
// @Failure 400 {object} map[string]interface{} "Bad request"
// @Failure 404 {object} map[string]interface{} "Chat not found"
// @Router /chats/{id} [put]
func UpdateChat(c echo.Context) error {
	return c.JSON(http.StatusOK, echo.Map{"message": "Chat updated"})
}

// DeleteChat supprime un chat par ID
// @Summary Delete a chat by ID
// @Description Delete a chat by its ID
// @Tags chat
// @Accept  json
// @Produce  json
// @Param id path int true "Chat ID"
// @Success 200 {object} map[string]interface{} "Chat deleted"
// @Failure 404 {object} map[string]interface{} "Chat not found"
// @Router /chats/{id} [delete]
func DeleteChat(c echo.Context) error {
	return c.JSON(http.StatusOK, echo.Map{"message": "Chat deleted"})
}
