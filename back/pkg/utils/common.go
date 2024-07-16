package utils

import (
	"log"
	"math/rand"
	"os"
	"strings"
	"time"

	"net/http"

	"github.com/golang-jwt/jwt"
	"github.com/labstack/echo/v4"

	"github.com/joho/godotenv"
	"golang.org/x/crypto/bcrypt"
)

func GetEnvVariable(key string) string {
	// load .env file
	err := godotenv.Load(".env.local")

	if err != nil {
		log.Fatalf("Error loading .env file")
	}

	return os.Getenv(key)
}

func MergeSlices[T any](slices ...[]T) []T {
	var mergedSlice []T

	for _, slice := range slices {
		mergedSlice = append(mergedSlice, slice...)
	}

	return mergedSlice
}

func Map[T any, S any](slice []T, transform func(element T) S) []S {
	var newSlice []S

	for _, element := range slice {
		newElement := transform(element)
		newSlice = append(newSlice, newElement)
	}

	return newSlice
}

func HashPassword(password string) (string, error) {
	bytes, err := bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)
	return string(bytes), err
}

func IsPasswordMatchingHash(password, hash string) bool {
	err := bcrypt.CompareHashAndPassword([]byte(hash), []byte(password))
	return err == nil
}

func GenerateRandomString(length int) string {
	charset := "ABCDEFGHIJKLMNPQRSTUVWXYZ123456789"
	seededRand := rand.New(rand.NewSource(time.Now().UnixNano()))
	b := make([]byte, length)
	for i := range b {
		b[i] = charset[seededRand.Intn(len(charset))]
	}
	return string(b)
}

func GetTokenFromHeader(c echo.Context) (jwt.MapClaims, error) {
	tokenString := c.Request().Header.Get("Authorization")

	if tokenString == "" {
		return nil, echo.NewHTTPError(http.StatusBadRequest, "No token provided")
	}

	tokenString = strings.Replace(tokenString, "Bearer ", "", 1)

	token, err := jwt.Parse(tokenString, func(token *jwt.Token) (interface{}, error) {
		return []byte(GetEnvVariable("JWT_SECRET")), nil
	})

	if err != nil {
		return nil, err
	}

	claims, ok := token.Claims.(jwt.MapClaims)
	if !ok || !token.Valid {
		return nil, echo.NewHTTPError(http.StatusBadRequest, "Invalid token")
	}

	return claims, nil
}
