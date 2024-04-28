package controllers

import (
	"easynight/internal/models"
	"easynight/internal/services"
	"net/http"

	"github.com/google/uuid"
	"github.com/labstack/echo/v4"
)

type RegistrationPayload struct {
	Credentials
	Firstname string `json:"firstname" validate:"required"`
	Lastname  string `json:"lastname" validate:"required"`
}

func doesUserAlreadyExists(email string) bool {
	user := services.GetUserByEmail(email)

	return user.ID != uuid.Nil
}

// @Summary	Register as customer
// @Tags		Users
// @Accept		json
// @Produce	json
// @Param		body	body		RegistrationPayload	true	"Registration payload"
// @Success	200		{object}	interface{}
// @Failure	400		{object}	error
// @Failure	404		{object}	error
// @Failure	500		{object}	error
// @Router		/customers [post]
func CustomerRegistration(c echo.Context) error {
	body := new(RegistrationPayload)

	if err := c.Bind(body); err != nil {
		return c.String(http.StatusBadRequest, "Bad request")
	}

	if err := c.Validate(body); err != nil {
		return c.String(http.StatusUnprocessableEntity, err.Error())
	}

	if doesUserAlreadyExists(body.Email) {
		return c.String(http.StatusConflict, "User already exists")
	}

	user, err := services.CreateUser(
		models.User{
			Email:    body.Email,
			Password: body.Password,
		},
	)

	if err != nil {
		return c.String(http.StatusUnprocessableEntity, "Unprocessable entity")
	}

	customer, err := services.CreateCustomer(
		models.Customer{
			UserID:    user.ID,
			User:      user,
			Firstname: body.Firstname,
			Lastname:  body.Lastname,
		},
	)

	if err != nil {
		return c.String(http.StatusUnprocessableEntity, "Unprocessable entity")
	}

	return c.JSON(http.StatusOK, customer)
}

// @Summary	Register as organizer
// @Tags		Users
// @Accept		json
// @Produce	json
// @Param		body	body		RegistrationPayload	true	"Registration payload"
// @Success	200		{object}	interface{}
// @Failure	400		{object}	error
// @Failure	409		{object}	error
// @Failure	500		{object}	error
// @Router		/organizers [post]
func OrganizerRegistration(c echo.Context) error {
	body := new(RegistrationPayload)

	if err := c.Bind(body); err != nil {
		return echo.NewHTTPError(http.StatusUnprocessableEntity, err.Error())
	}

	if err := c.Validate(body); err != nil {
		return echo.NewHTTPError(http.StatusUnprocessableEntity, err.Error())
	}

	if doesUserAlreadyExists(body.Email) {
		return echo.NewHTTPError(http.StatusUnprocessableEntity, "User already exists")
	}

	user, err := services.CreateUser(
		models.User{
			Email:    body.Email,
			Password: body.Password,
		},
	)

	if err != nil {
		return echo.NewHTTPError(http.StatusInternalServerError, err.Error())
	}

	organizer, err := services.CreateOrganizer(
		models.Organizer{
			UserID:    user.ID,
			User:      user,
			Firstname: body.Firstname,
			Lastname:  body.Lastname,
		},
	)

	if err != nil {
		return echo.NewHTTPError(http.StatusInternalServerError, err.Error())
	}

	return c.JSON(http.StatusOK, organizer)
}
