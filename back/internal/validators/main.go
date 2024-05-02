package validators

import (
	"github.com/go-playground/validator"
	"github.com/labstack/echo/v4"
)

type CustomValidator struct {
	validator *validator.Validate
}

func (cv *CustomValidator) Validate(i interface{}) error {
	return cv.validator.Struct(i)
}

func InitValidators(e *echo.Echo) {
	validator := validator.New()
	e.Validator = &CustomValidator{validator: validator}
}
