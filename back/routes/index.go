package routes

import (
	"echoApi/controllers"

	"github.com/labstack/echo/v4"
)

func InitRouter(e *echo.Echo) {
	e.GET("/", controllers.GetDefault)
}