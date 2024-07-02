package controllers

import (
	"easynight/internal/db"
	"easynight/internal/models"
	"net/http"
	"time"

	"github.com/google/uuid"
	"github.com/labstack/echo/v4"
)

type OrganizerInput struct {
	UserID    uuid.UUID `json:"user_id"`
	Firstname string    `json:"firstname"`
	Lastname  string    `json:"lastname"`
}

// CreateOrganizer godoc
// @Summary Create a new organizer
// @Description Create a new organizer
// @Tags organizers
// @Accept json
// @Produce json
// @Param organizer body OrganizerInput true "Organizer Input"
// @Success 201 {object} models.Organizer
// @Router /organizers [post]
func CreateOrganizer(c echo.Context) error {
	var input OrganizerInput
	if err := c.Bind(&input); err != nil {
		return c.JSON(http.StatusBadRequest, err)
	}

	organizer := models.Organizer{
		UserID:    input.UserID,
		Firstname: input.Firstname,
		Lastname:  input.Lastname,
		CreatedAt: time.Now(),
		UpdatedAt: time.Now(),
	}

	if err := db.DB().Create(&organizer).Error; err != nil {
		return c.JSON(http.StatusInternalServerError, err)
	}

	return c.JSON(http.StatusCreated, organizer)
}

// GetOrganizer godoc
// @Summary Get an organizer by ID
// @Description Get an organizer by ID
// @Tags organizers
// @Produce json
// @Param id path string true "Organizer ID"
// @Success 200 {object} models.Organizer
// @Router /organizers/{id} [get]
func GetOrganizer(c echo.Context) error {
	id := c.Param("id")
	var organizer models.Organizer
	if err := db.DB().First(&organizer, "user_id = ?", id).Error; err != nil {
		return c.JSON(http.StatusNotFound, err)
	}
	return c.JSON(http.StatusOK, organizer)
}

// GetAllOrganizers godoc
// @Summary Get all organizers
// @Description Get all organizers
// @Tags organizers
// @Produce json
// @Success 200 {array} models.Organizer
// @Router /organizers [get]
func GetAllOrganizers(c echo.Context) error {
	var organizers []models.Organizer
	if err := db.DB().Find(&organizers).Error; err != nil {
		return c.JSON(http.StatusInternalServerError, err)
	}
	return c.JSON(http.StatusOK, organizers)
}

// UpdateOrganizer godoc
// @Summary Update an organizer by ID
// @Description Update an organizer by ID
// @Tags organizers
// @Accept json
// @Produce json
// @Param id path string true "Organizer ID"
// @Param organizer body OrganizerInput true "Organizer Input"
// @Success 200 {object} models.Organizer
// @Router /organizers/{id} [put]
func UpdateOrganizer(c echo.Context) error {
	id := c.Param("id")
	var organizer models.Organizer
	if err := db.DB().First(&organizer, "user_id = ?", id).Error; err != nil {
		return c.JSON(http.StatusNotFound, err)
	}

	var input OrganizerInput
	if err := c.Bind(&input); err != nil {
		return c.JSON(http.StatusBadRequest, err)
	}

	organizer.Firstname = input.Firstname
	organizer.Lastname = input.Lastname
	organizer.UpdatedAt = time.Now()

	if err := db.DB().Save(&organizer).Error; err != nil {
		return c.JSON(http.StatusInternalServerError, err)
	}

	return c.JSON(http.StatusOK, organizer)
}

// DeleteOrganizer godoc
// @Summary Delete an organizer by ID
// @Description Delete an organizer by ID
// @Tags organizers
// @Produce json
// @Param id path string true "Organizer ID"
// @Success 204
// @Router /organizers/{id} [delete]
func DeleteOrganizer(c echo.Context) error {
	id := c.Param("id")
	if err := db.DB().Delete(&models.Organizer{}, "user_id = ?", id).Error; err != nil {
		return c.JSON(http.StatusInternalServerError, err)
	}
	return c.NoContent(http.StatusNoContent)
}
