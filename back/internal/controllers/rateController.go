package controllers

import (
	"easynight/internal/db"
	"easynight/internal/models"
	"net/http"
	"time"

	"github.com/google/uuid"
	"github.com/labstack/echo/v4"
)
type RateInput struct {
	UserID  uuid.UUID `json:"user_id"`
	EventID uuid.UUID `json:"event_id"`
	Comment string    `json:"comment"`
	Note    int       `json:"note"`
}
// CreateRate godoc
// @Summary Create a new rate
// @Description Create a new rate
// @Tags rates
// @Accept json
// @Produce json
// @Param rate body RateInput true "Rate Input"
// @Success 201 {object} models.Rate
// @Router /rates [post]
func CreateRate(c echo.Context) error {
	var input RateInput
	if err := c.Bind(&input); err != nil {
		return c.JSON(http.StatusBadRequest, err)
	}

	rate := models.Rate{
		UserID:  input.UserID,
		EventID: input.EventID,
		Comment: input.Comment,
		Note:    input.Note,
	}

	if err := db.DB().Create(&rate).Error; err != nil {
		return c.JSON(http.StatusInternalServerError, err)
	}

	return c.JSON(http.StatusCreated, rate)
}

// GetRate godoc
// @Summary Get a rate by ID
// @Description Get a rate by ID
// @Tags rates
// @Produce json
// @Param id path string true "Rate ID"
// @Success 200 {object} models.Rate
// @Router /rates/{id} [get]
func GetRate(c echo.Context) error {
	id := c.Param("id")
	var rate models.Rate
	if err := db.DB().First(&rate, "id = ?", id).Error; err != nil {
		return c.JSON(http.StatusNotFound, err)
	}
	return c.JSON(http.StatusOK, rate)
}

// GetAllRates godoc
// @Summary Get all rates
// @Description Get all rates
// @Tags rates
// @Produce json
// @Success 200 {array} models.Rate
// @Router /rates [get]
func GetAllRates(c echo.Context) error {
	var rates []models.Rate
	if err := db.DB().Find(&rates).Error; err != nil {
		return c.JSON(http.StatusInternalServerError, err)
	}
	return c.JSON(http.StatusOK, rates)
}
// UpdateRate godoc
// @Summary Update a rate by ID
// @Description Update a rate by ID
// @Tags rates
// @Accept json
// @Produce json
// @Param id path string true "Rate ID"
// @Param rate body RateInput true "Rate Input"
// @Success 200 {object} models.Rate
// @Router /rates/{id} [put]
func UpdateRate(c echo.Context) error {
	id := c.Param("id")
	var rate models.Rate
	if err := db.DB().First(&rate, "id = ?", id).Error; err != nil {
		return c.JSON(http.StatusNotFound, err)
	}

	var input RateInput
	if err := c.Bind(&input); err != nil {
		return c.JSON(http.StatusBadRequest, err)
	}

	rate.UserID = input.UserID
	rate.EventID = input.EventID
	rate.Comment = input.Comment
	rate.Note = input.Note
	rate.UpdatedAt = time.Now()

	if err := db.DB().Save(&rate).Error; err != nil {
		return c.JSON(http.StatusInternalServerError, err)
	}

	return c.JSON(http.StatusOK, rate)
}
// DeleteRate godoc
// @Summary Delete a rate by ID
// @Description Delete a rate by ID
// @Tags rates
// @Produce json
// @Param id path string true "Rate ID"
// @Success 204
// @Router /rates/{id} [delete]
func DeleteRate(c echo.Context) error {
	id := c.Param("id")
	if err := db.DB().Delete(&models.Rate{}, "id = ?", id).Error; err != nil {
		return c.JSON(http.StatusInternalServerError, err)
	}
	return c.NoContent(http.StatusNoContent)
}
