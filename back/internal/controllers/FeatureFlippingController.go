package controllers

import (
	"net/http"

	"easynight/internal/db"
	"easynight/internal/models"

	"github.com/labstack/echo/v4"
)

func GetAllFeatures(c echo.Context) error {
	features := []models.FeatureFlipping{}
	db.DB().Find(&features)

	return c.JSON(http.StatusOK, features)
}

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