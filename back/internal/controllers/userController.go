package controllers

import (
	"easynight/internal/db"
	"easynight/internal/models"
	"easynight/internal/services"
	"easynight/pkg/utils"
	"log"
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
		return echo.NewHTTPError(http.StatusUnprocessableEntity, err.Error())
	}

	if err := c.Validate(body); err != nil {
		return echo.NewHTTPError(http.StatusUnprocessableEntity, err.Error())
	}

	if doesUserAlreadyExists(body.Email) {
		return echo.NewHTTPError(http.StatusUnprocessableEntity, "User already exists")
	}

	hashedPassword, err := utils.HashPassword(body.Password)

	if err != nil {
		return echo.NewHTTPError(http.StatusInternalServerError, err.Error())
	}

	user, err := services.CreateUser(
		models.User{
			Email:    body.Email,
			Password: hashedPassword,
			Role:     "customer",
		},
	)

	if err != nil {
		return echo.NewHTTPError(http.StatusUnprocessableEntity, err.Error())
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

	return c.JSON(http.StatusCreated, customer)
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
		return echo.NewHTTPError(http.StatusConflict, "User already exists")
	}

	hashedPassword, err := utils.HashPassword(body.Password)

	if err != nil {
		return echo.NewHTTPError(http.StatusInternalServerError, err.Error())
	}

	user, err := services.CreateUser(
		models.User{
			Email:    body.Email,
			Password: hashedPassword,
			Role:     "organizer",
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

	return c.JSON(http.StatusCreated, organizer)
}

type UserInput struct {
	Firstname   string `json:"firstname"`
	Lastname    string `json:"lastname"`
	Email       string `json:"email"`
	Password    string `json:"password"`
	NewPassword string `json:"newPassword"`
}

// // @Summary Get user role from token
// // @Tags Users
// // @Accept json
// // @Produce json
// // @Security ApiKeyAuth
// // @Success 200 {object} map[string]string{"role": "user role"}
// // @Failure 400 {object} map[string]string{"error": "error message"}
// // @Failure 500 {object} map[string]string{"error": "error message"}
// // @Router /role [get]
// func GetRole(c echo.Context) error {
// 	claims, err := utils.GetTokenFromHeader(c)
// 	if err != nil {
// 		return c.JSON(http.StatusBadRequest, map[string]string{"error": err.Error()})
// 	}

// 	return c.JSON(http.StatusOK, map[string]string{"role": claims["role"].(string)})

// }

type Result struct {
	Firstname string
	Lastname  string
	Email     string
	Password  string
}

// @Summary Get user by ID Customer
// @Description Retrieve user details by user ID, including first name, last name, email, and password.
// @Tags Users
// @Accept json
// @Produce json
// @Security ApiKeyAuth
// @Param id path string true "User ID"
// @Success 200 {array} Result
// @Failure 400 {object} error "Bad request"
// @Failure 500 {object} error "Internal server error"
// @Router /users/custom/{id} [get]
func GetUserByIdCustomer(c echo.Context) error {

	userIDparam := c.Param("id")

	var results []Result

	if err := db.DB().Table("users").Select(" users.email, users.password, customers.firstname, customers.lastname ").
		Joins("JOIN customers on users.id = customers.user_id").
		Where("users.id = ? AND users.deleted_at IS NULL", userIDparam).
		Find(&results).Error; err != nil {
		return c.JSON(http.StatusBadRequest, map[string]string{"error": err.Error()})

	}
	log.Println(results)

	if len(results) == 0 {
		return c.JSON(http.StatusOK, []Result{})
	}

	return c.JSON(http.StatusOK, results)
}

// @Summary Get user by ID
// @Description Retrieve user details by user ID, including first name, last name, email, and password.
// @Tags Users
// @Accept json
// @Produce json
// @Security ApiKeyAuth
// @Param id path string true "User ID"
// @Success 200 {array} Result
// @Failure 400 {object} error "Bad request"
// @Failure 500 {object} error "Internal server error"
// @Router /users/orga/{id} [get]
func GetUserByIdOrga(c echo.Context) error {

	userIDparam := c.Param("id")

	var results []Result

	if err := db.DB().Table("users").Select(" users.email, users.password, organizers.firstname, organizers.lastname ").
		Joins("JOIN organizers on users.id = organizers.user_id").
		Where("users.id = ? AND users.deleted_at IS NULL", userIDparam).
		Find(&results).Error; err != nil {
		return c.JSON(http.StatusBadRequest, map[string]string{"error": err.Error()})

	}
	log.Println(results)

	if len(results) == 0 {
		return c.JSON(http.StatusOK, []Result{})
	}

	return c.JSON(http.StatusOK, results)
}
