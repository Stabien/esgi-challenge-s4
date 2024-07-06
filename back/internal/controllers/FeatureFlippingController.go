package controllers

import (
	"net/http"

	"easynight/internal/db"
	"easynight/internal/models"

	"github.com/labstack/echo/v4"
)

// @Summary Get all features
// @Description Get all features
// @Tags Feature Flipping
// @Accept json
// @Produce json
// @Success 200 {object} []models.FeatureFlipping
// @Router /features [get]
func GetAllFeatures(c echo.Context) error {
	features := []models.FeatureFlipping{}
	db.DB().Find(&features)

	return c.JSON(http.StatusOK, features)
}

// @Summary Get feature state
// @Description Get feature state
// @Tags Feature Flipping
// @Accept json
// @Produce json
// @Param name path string true "Feature name"
// @Success 200 {object} bool
// @Router /features/{name} [get]
func IsEnabled(c echo.Context) error {
	featureName := c.Param("name")

	if featureName == "" {
		return c.JSON(http.StatusBadRequest, "Feature name is required")
	}

	feature := models.FeatureFlipping{}
	db.DB().Table("feature_flippings").Where("name = ?", featureName).First(&feature)

	if feature.ID == [16]byte{} {
		return c.JSON(http.StatusNotFound, "Feature not found")
	}

	return c.JSON(http.StatusOK, feature.IsEnabled)
}

// @Summary Update feature state
// @Description Update feature state
// @Tags Feature Flipping
// @Accept json
// @Produce json
// @Param feature formData string true "Feature name"
// @Param is_enabled formData string true "State"
// @Success 200 {object} models.FeatureFlipping
// @Router /features [patch]
func UpdateState(c echo.Context) error {
	featureName := c.FormValue("feature")
	isEnabled := c.FormValue("is_enabled")

	if featureName == "" {
		return c.JSON(http.StatusBadRequest, "Feature name is required")
	}

	if isEnabled == "" {
		return c.JSON(http.StatusBadRequest, "State is required")
	}

	feature := models.FeatureFlipping{}
	db.DB().Table("feature_flippings").Where("name = ?", featureName).First(&feature)

	if feature.ID == [16]byte{} {
		return c.JSON(http.StatusNotFound, "Feature not found")
	}

	if isEnabled == "true" {
		feature.IsEnabled = true
	} else {
		feature.IsEnabled = false
	}

	db.DB().Save(&feature)

	return c.JSON(http.StatusOK, feature)
}