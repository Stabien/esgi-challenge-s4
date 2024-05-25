package routes

import (
	"easynight/internal/controllers"

	"github.com/labstack/echo/v4"
	echoSwagger "github.com/swaggo/echo-swagger"
)

func InitRouter(e *echo.Echo) {
	e.GET("/swagger/*", echoSwagger.WrapHandler)

	e.POST("/event", controllers.CreateEvent)
	e.DELETE("/event/:id", controllers.DeleteEvent)
	e.PATCH("/event/:id", controllers.UpdateEvent)
	e.GET("/event/:id", controllers.GetEvent)
	e.GET("/events", controllers.GetAllEvents)
	e.GET("/events/today", controllers.GetAllEventsToday)
	// e.POST("/event/:id/code", controllers.CreateCode)
	e.POST("/event/join/:code", controllers.JoinEvent)
	e.GET("/events/organizer", controllers.GetEventsByOrganizer)

	e.GET("/reservations/isreserv/:customerId/:eventId", controllers.IsReserv)

	e.POST("/reservations", controllers.PostReservation)
	e.DELETE("/reservations", controllers.DeleteReservation)
	e.GET("/reservations/:customerId", controllers.GetReservationsbyUser)

	e.POST("/auth", controllers.Authentication)
	e.POST("/customers", controllers.CustomerRegistration)
	e.POST("/organizers", controllers.OrganizerRegistration)

	e.POST("/send-notification", controllers.SendNotification)
	e.GET("/logs", controllers.GetAllLogs) // TODO: add middleware to check if user is admin
}
