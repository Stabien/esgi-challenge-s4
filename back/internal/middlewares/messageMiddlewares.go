package middlewares

import (
	"easynight/internal/services"
	"easynight/pkg/utils"
	"net/http"

	"github.com/labstack/echo/v4"
)

func CheckMessageBelongsToOrganizer(next echo.HandlerFunc) echo.HandlerFunc {
	return func(c echo.Context) error {
		token, error := utils.GetTokenFromHeader(c)

		if error != nil {
			return echo.NewHTTPError(http.StatusUnauthorized)
		}
		
		if token["role"] == "admin" {
			return next(c)
		}

		message := services.GetMessageByID(c.Param("id"))

		if message.OrganizerID != token["id"] {
			return echo.NewHTTPError(http.StatusInternalServerError)
		}

		return next(c)
	}
}
