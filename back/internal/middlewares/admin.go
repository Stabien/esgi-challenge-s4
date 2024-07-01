package middlewares

import (
	"net/http"

	"github.com/labstack/echo/v4"
)

// CheckAdminMiddleware vérifie si l'utilisateur est administrateur
func CheckAdminMiddleware(next echo.HandlerFunc) echo.HandlerFunc {
    return func(c echo.Context) error {
        isAdmin, ok := c.Get("isAdmin").(bool)
        if !ok || !isAdmin {
            return c.JSON(http.StatusForbidden, echo.Map{"error": "Forbidden"})
        }

        return next(c)
    }
}