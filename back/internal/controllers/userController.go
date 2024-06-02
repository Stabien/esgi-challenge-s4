package controllers

import (
	"easynight/internal/db"

	"easynight/internal/models"
	"easynight/internal/services"
	"easynight/pkg/utils"
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

	user, err := services.CreateUser(
		models.User{
			Email:    body.Email,
			Password: body.Password,
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

type UserInput struct {
	Email    string `json:"email"`
	Password string `json:"password"`
}


// GetUser récupère un utilisateur par ID
// @Summary Get an user by ID
// @Description Retrieve an user based on its unique ID
// @Tags users
// @Produce json
// @Param id path string true "User ID"
// @Success 200 {object} models.User
// @Router /users/{id} [get]
func GetUser(c echo.Context) error {

	id, err := uuid.Parse(c.Param("id"))
	if err != nil {
		return err
	}

	var user models.User
	if err := db.DB().First(&user, "id = ?", id).Error; err != nil {
		return err
	}

	return c.JSON(http.StatusOK, user)
}

// GetAllUsers récupère tous les utilisateurs
// @Summary Get all users
// @Description Retrieve all users from the database
// @Tags users
// @Produce json
// @Success 200 {array} models.User
// @Router /users [get]
func GetAllUsers(c echo.Context) error {

	var users []models.User
	if err := db.DB().Find(&users).Error; err != nil {
		return err
	}

	return c.JSON(http.StatusOK, users)
}

// UpdateUser met à jour un utilisateur par ID
// @Summary Update an user by ID
// @Description Update an existing user identified by its ID
// @Tags users
// @Accept json
// @Produce json
// @Param id path string true "User ID"
// @Param user body UserInput true "Updated user data"
// @Success 200 {object} models.User
// @Router /users/{id} [put]
func UpdateUser(c echo.Context) error {
	id, err := uuid.Parse(c.Param("id"))
	if err != nil {
		return err
	}

	var user models.User
	if err := db.DB().First(&user, "id = ?", id).Error; err != nil {
		return err
	}

	var input UserInput
	if err := c.Bind(&input); err != nil {
		return err
	}

	user.Email = input.Email
	user.Password = input.Password

	if err := db.DB().Save(&user).Error; err != nil {
		return err
	}

	return c.JSON(http.StatusOK, user)
}


// CreateUser crée un nouvel utilisateur
// @Summary Create a new user
// @Description Create a new user with the provided data
// @Tags users
// @Accept json
// @Produce json
// @Param user body UserInput true "User data"
// @Success 201 {object} models.User
// @Router /users [post]
func CreateUser(c echo.Context) error {

	var input UserInput
	if err := c.Bind(&input); err != nil {
		return err
	}

	user := models.User{
		Email:    input.Email,
		Password: input.Password,
	}

	if err := db.DB().Create(&user).Error; err != nil {
		return err
	}

	return c.JSON(http.StatusCreated, user)
}

// DeleteUser supprime un utilisateur par ID
// @Summary Delete a user by ID
// @Description Delete an existing user identified by its ID
// @Tags users
// @Param id path string true "User ID"
// @Success 204 "No Content"
// @Router /users/{id} [delete]
func DeleteUser(c echo.Context) error {

	id, err := uuid.Parse(c.Param("id"))
	if err != nil {
		return err
	}

	var user models.User
	if err := db.DB().First(&user, "id = ?", id).Error; err != nil {
		return err
	}

	if err := db.DB().Delete(&user).Error; err != nil {
		return err
	}

	return c.NoContent(http.StatusNoContent)
}