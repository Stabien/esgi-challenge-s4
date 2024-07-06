package controllers

import (
	"net/http"

	"easynight/internal/db"
	"easynight/internal/models"

	"github.com/labstack/echo/v4"
)

func EnableFeature(c echo.Context) error {
	featureName := c.QueryParam("feature")

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
