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
	Email    string `json:"email"`
	Password string `json:"password"`
}

type AuthSuccessResponse struct {
	Token string `json:"token"`
}

type jwtClaims struct {
	ID    uuid.UUID `json:"id"`
	Email string    `json:"email"`
	jwt.StandardClaims
}

func Authentication(c echo.Context) error {
	var user models.User

	credentials := new(Credentials)

	if err := c.Bind(credentials); err != nil {
		return c.String(http.StatusBadRequest, "bad request")
	}

	db := db.DB()
	db.Where(credentials).Find(&user)

	token, err := generateJwtToken(user.ID, user.Email, time.Now())

	if err != nil {
		return c.JSON(http.StatusInternalServerError, "internal server error")
	}

	return c.JSON(http.StatusOK, AuthSuccessResponse{Token: token})
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
