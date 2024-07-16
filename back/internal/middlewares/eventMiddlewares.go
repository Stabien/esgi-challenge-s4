package middlewares

import (
	"easynight/internal/models"
	"easynight/internal/services"
	"easynight/pkg/utils"
	"fmt"
	"net/http"

	"github.com/google/uuid"
	"github.com/labstack/echo/v4"
)

func CheckSenderBelongsToEvent(next echo.HandlerFunc) echo.HandlerFunc {
	return func(c echo.Context) error {
		var message models.Message

		token, error := utils.GetTokenFromHeader(c)

		if error != nil {
			return echo.NewHTTPError(http.StatusUnauthorized)
		}

		err := c.Bind(&message)

		if err != nil {
			return echo.NewHTTPError(http.StatusInternalServerError, err)
		}

		if token["role"] == "admin" {
			return next(c)
		}

		fmt.Print(message.EventID, message.OrganizerID, token["id"])

		doesOrganizerBelongsToEvent := services.DoesOrganizerBelongsToEvent(message.EventID, message.OrganizerID)

		if !doesOrganizerBelongsToEvent {
			return echo.NewHTTPError(http.StatusUnauthorized)
		}

		return next(c)
	}
}

func CheckEventBelongsToOrganizer(next echo.HandlerFunc) echo.HandlerFunc {
	return func(c echo.Context) error {
		token, err := utils.GetTokenFromHeader(c)
		eventId := c.Param("id")

		if err != nil {
			return echo.NewHTTPError(http.StatusUnauthorized, err)
		}

		if token["role"] == "admin" {
			return next(c)
		}

		eventUUID, err := uuid.Parse(eventId)

		if err != nil {
			return echo.NewHTTPError(http.StatusInternalServerError, err)
		}

		organizerUUID, err := uuid.Parse(token["id"].(string))

		if err != nil {
			return echo.NewHTTPError(http.StatusInternalServerError, err)
		}

		if !services.DoesOrganizerBelongsToEvent(eventUUID, organizerUUID) {
			return echo.NewHTTPError(http.StatusUnauthorized)
		}

		return next(c)
	}
}
