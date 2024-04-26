package routes

import (
	"easynight/internal/controllers"

	"github.com/labstack/echo/v4"
)

func InitRouter(e *echo.Echo) {
	e.POST("/event", controllers.CreateEvent)
	e.PATCH("/event/:id", controllers.UpdateEvent)
	e.GET("/event/:id", controllers.GetEvent)

	e.POST("/user/authentication", controllers.Authentication)
}
