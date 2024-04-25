package controllers

import (
	"net/http"

	"github.com/labstack/echo/v4"
)

// @summary		Get pet by ID
// @description	Gets a pet using the pet ID
// @id				get-pet-by-id
// @produce		json
// @Param			id	path		int	true	"Pet ID"
// @Success		200	{object}	string
// @Success		400	{object}	error
// @Success		404	{object}	error
// @Success		405	{object}	error
// @Router			/api/v1/pets/{id} [get]
// @tags			Pets
func GetDefault(c echo.Context) error {
	return c.String(http.StatusOK, "Hello world !")
}
