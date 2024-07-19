package controllers

import (
	"bytes"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/labstack/echo/v4"
	"github.com/stretchr/testify/assert"
)

func TestCustomerRegistration(t *testing.T) {
	e := echo.New()
	payload := `{"firstname":"John","lastname":"Doe","email":"john@example.com","password":"password123"}`
	req := httptest.NewRequest(http.MethodPost, "/customers", bytes.NewBufferString(payload))
	req.Header.Set(echo.HeaderContentType, echo.MIMEApplicationJSON)
	rec := httptest.NewRecorder()
	c := e.NewContext(req, rec)

	if assert.NoError(t, CustomerRegistration(c)) {
		assert.Equal(t, http.StatusCreated, rec.Code)
	}
}

func TestOrganizerRegistration(t *testing.T) {
	e := echo.New()
	payload := `{"firstname":"Jane","lastname":"Doe","email":"jane@example.com","password":"password123"}`
	req := httptest.NewRequest(http.MethodPost, "/organizers", bytes.NewBufferString(payload))
	req.Header.Set(echo.HeaderContentType, echo.MIMEApplicationJSON)
	rec := httptest.NewRecorder()
	c := e.NewContext(req, rec)

	if assert.NoError(t, OrganizerRegistration(c)) {
		assert.Equal(t, http.StatusCreated, rec.Code)
	}
}

func TestGetUserByIdCustomer(t *testing.T) {
	e := echo.New()
	req := httptest.NewRequest(http.MethodGet, "/users/custom/1", nil)
	rec := httptest.NewRecorder()
	c := e.NewContext(req, rec)
	c.SetPath("/users/custom/:id")
	c.SetParamNames("id")
	c.SetParamValues("1")

	if assert.NoError(t, GetUserByIdCustomer(c)) {
		assert.Equal(t, http.StatusOK, rec.Code)
		// Add more assertions based on the expected response structure
	}
}

func TestGetUserByIdOrga(t *testing.T) {
	e := echo.New()
	req := httptest.NewRequest(http.MethodGet, "/users/orga/1", nil)
	rec := httptest.NewRecorder()
	c := e.NewContext(req, rec)
	c.SetPath("/users/orga/:id")
	c.SetParamNames("id")
	c.SetParamValues("1")

	if assert.NoError(t, GetUserByIdOrga(c)) {
		assert.Equal(t, http.StatusOK, rec.Code)
		// Add more assertions based on the expected response structure
	}
}