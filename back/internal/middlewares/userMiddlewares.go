package middlewares

import (
	"easynight/internal/models"
	"easynight/pkg/utils"
	"net/http"

	"github.com/labstack/echo/v4"
)

func CheckUserRole(next echo.HandlerFunc, role string) echo.HandlerFunc {
	return func(c echo.Context) error {
		token, error := utils.GetTokenFromHeader(c)

		if error != nil {
			return echo.NewHTTPError(http.StatusUnauthorized)
		}

		if token["role"] == "admin" || token["role"] == role {
			return next(c)
		}

		return next(c)
	}
}

func CheckUserId(next echo.HandlerFunc) echo.HandlerFunc {
	return func(c echo.Context) error {
		token, error := utils.GetTokenFromHeader(c)
		userId := c.Param("id")

		if error != nil {
			return echo.NewHTTPError(http.StatusUnauthorized)
		}

		if token["role"] == "admin" {
			return next(c)
		}

		if token["id"] != userId {
			return echo.NewHTTPError(http.StatusUnauthorized)
		}

		return next(c)
	}
}

func CheckUserRoleAndId(next echo.HandlerFunc, role string) echo.HandlerFunc {
	return func(c echo.Context) error {
		token, error := utils.GetTokenFromHeader(c)
		userId := c.Param("id")

		if error != nil {
			return echo.NewHTTPError(http.StatusUnauthorized)
		}

		if token["role"] == "admin" {
			return next(c)
		}

		if token["role"] != role || token["id"] != userId {
			return echo.NewHTTPError(http.StatusUnauthorized)
		}

		return next(c)
	}
}

func CheckCustomerIdParam(next echo.HandlerFunc) echo.HandlerFunc {
	return func(c echo.Context) error {
		token, error := utils.GetTokenFromHeader(c)
		userId := c.Param("customerId")

		if error != nil {
			return echo.NewHTTPError(http.StatusUnauthorized)
		}

		if token["role"] == "admin" {
			return next(c)
		}

		if token["id"] != userId {
			return echo.NewHTTPError(http.StatusUnauthorized)
		}

		return next(c)
	}
}

func CheckCustomerIdBody(next echo.HandlerFunc) echo.HandlerFunc {
	return func(c echo.Context) error {
		var customer models.Customer

		token, error := utils.GetTokenFromHeader(c)

		if error != nil {
			return echo.NewHTTPError(http.StatusUnauthorized)
		}

		err := c.Bind(&customer)

		if err != nil {
			return echo.NewHTTPError(http.StatusInternalServerError, err)
		}

		if token["role"] == "admin" {
			return next(c)
		}

		if token["id"] != customer.User.ID {
			return echo.NewHTTPError(http.StatusUnauthorized)
		}

		return next(c)
	}
}
