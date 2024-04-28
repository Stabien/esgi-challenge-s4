package controllers

import (
	"easynight/internal/db"
	"easynight/internal/models"
	"easynight/pkg/utils"
	"net/http"
	"time"

	"github.com/golang-jwt/jwt"
	"github.com/google/uuid"
	"github.com/labstack/echo/v4"
)

type Credentials struct {
	Email    string `json:"email" validate:"required,email"`
	Password string `json:"password"`
}

type authSuccessResponse struct {
	Token string `json:"token"`
}

type jwtClaims struct {
	ID    uuid.UUID `json:"id"`
	Email string    `json:"email"`
	jwt.StandardClaims
}

// @Summary	Authenticate a user
// @Tags		users
// @Accept		json
// @Produce	json
// @Param		body		body		Credentials	true	"User credentials"
// @Success	200			{object}	AuthSuccessResponse
// @Failure	400			{object}	error
// @Failure	404			{object}	error
// @Failure	500			{object}	error
// @Router		/user/authentication [post]
func Authentication(c echo.Context) error {
	var user models.User

	credentials := new(Credentials)

	if err := c.Bind(credentials); err != nil {
		return c.String(http.StatusBadRequest, "Bad request")
	}

	query := map[string]interface{}{
		"email":    credentials.Email,
		"password": credentials.Password,
	}

	db := db.DB()
	db.Where(query).Find(&user)

	if user.ID == uuid.Nil {
		return c.String(http.StatusNotFound, "User not found")
	}

	token, err := generateJwtToken(user.ID, user.Email, time.Now().AddDate(0, 0, 7))

	if err != nil {
		return c.String(http.StatusInternalServerError, "Internal server error")
	}

	return c.JSON(http.StatusOK, authSuccessResponse{Token: token})
}

func generateJwtToken(userID uuid.UUID, userEmail string, expirationTime time.Time) (string, error) {
	claims := &jwtClaims{
		ID:    userID,
		Email: userEmail,
		StandardClaims: jwt.StandardClaims{
			ExpiresAt: expirationTime.Unix(),
		},
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	tokenString, err := token.SignedString([]byte(utils.GetEnvVariable("JWT_SECRET")))

	if err != nil {
		return "", err
	}

	return tokenString, nil
}
