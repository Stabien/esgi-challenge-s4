package controllers

import (
	"easynight/internal/db"
	"easynight/internal/models"
	"net/http"
	"strings"

	"github.com/labstack/echo/v4"
)

type TagInput struct {
	Id   string `json:"id"`
	Name string `json:"name"`
}

// CreateTag crée un nouveau tag
// @Summary Create a new Tag
// @Tags LesTag
// @Accept json
// @Produce json
// @Param tag body TagInput true "Tag name"
// @Success 201 {object} models.Tag "Tag created successfully!"
// @Failure 400 {object} map[string]string "Bad request"
// @Failure 500 {object} map[string]string "Internal server error"
// @Router /tag [post]
func CreateTag(c echo.Context) error {
	var input TagInput
	if err := c.Bind(&input); err != nil {
		return c.JSON(http.StatusBadRequest, map[string]string{"error": err.Error()})
	}

	// Convertit le nom du tag en minuscule avant de le sauvegarder
	tag := models.Tag{
		Name: strings.ToLower(input.Name),
	}

	if err := db.DB().Create(&tag).Error; err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{"error": err.Error()})
	}

	return c.JSON(http.StatusCreated, tag)
}

// GetTags récupère tous les tags
// @Summary Get all Tags
// @Tags LesTag
// @Produce json
// @Success 200 {array} models.Tag "List of tags"
// @Failure 500 {object} map[string]string "Internal server error"
// @Router /tags [get]
func GetTags(c echo.Context) error {
	var tags []models.Tag
	if err := db.DB().Where("deleted_at IS NULL").Find(&tags).Error; err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{"error": err.Error()})
	}

	return c.JSON(http.StatusOK, tags)
}

// DeleteTag supprime un tag par son ID
// @Summary Delete a Tag by ID
// @Tags LesTag
// @Accept json
// @Produce json
// @Param id path string true "Tag ID"
// @Success 204 "Tag deleted successfully"
// @Failure 400 {object} map[string]string "Bad request"
// @Failure 404 {object} map[string]string "Tag not found"
// @Failure 500 {object} map[string]string "Internal server error"
// @Router /tag/{id} [delete]
func DeleteTag(c echo.Context) error {
	id := c.Param("id")
	print("----------------------", id)

	var tag models.Tag
	if err := db.DB().Where("id = ?", id).First(&tag).Error; err != nil {
		return c.JSON(http.StatusNotFound, map[string]string{"error": "Tag not found"})
	}

	if err := db.DB().Delete(&tag).Error; err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{"error": err.Error()})
	}

	return c.NoContent(http.StatusNoContent)
}
