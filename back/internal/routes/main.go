package routes

import (
	"easynight/internal/controllers"

	"github.com/labstack/echo/v4"
	echoSwagger "github.com/swaggo/echo-swagger"
)

func InitRouter(e *echo.Echo) {
	e.GET("/swagger/*", echoSwagger.WrapHandler)

	e.POST("/event", controllers.CreateEvent)
	e.PATCH("/event/:id", controllers.UpdateEvent)
	e.GET("/event/:id", controllers.GetEvent)
	e.GET("/events", controllers.GetAllEvents)

	e.POST("/auth", controllers.Authentication)
	e.POST("/customers", controllers.CustomerRegistration)
	e.POST("/organizers", controllers.OrganizerRegistration)
}
