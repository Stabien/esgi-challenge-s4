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
	e.POST("/event/:id/code", controllers.CreateCode)
	e.POST("/event/join/:code", controllers.JoinEvent)
	e.GET("/events/organizer/:id", controllers.GetEventsByOrganizer)

	e.GET("/reservations/isreserv/:customerId/:eventId", controllers.IsReserv)

	e.POST("/reservations", controllers.PostReservation)
	e.DELETE("/reservations", controllers.DeleteReservation)
	e.GET("/reservations/:customerId", controllers.GetReservationsbyUser)

	e.POST("/auth", controllers.Authentication)
	e.POST("/customers", controllers.CustomerRegistration)
	e.POST("/organizers", controllers.OrganizerRegistration)

	e.POST("/send-notification", controllers.SendNotification)
	e.GET("/logs", controllers.GetAllLogs) // TODO: add middleware to check if user is admin


	// Admin
    // Groupes de routes protégées par le middleware CheckAdminMiddleware
    adminRoutes := authRoutes.Group("/admin")
    adminRoutes.Use(middlewares.CheckAdminMiddleware)

       // User routes
    adminRoutes.POST("/users", controllers.CreateUser)
    adminRoutes.GET("/users/:id", controllers.GetUser)
    adminRoutes.PUT("/users/:id", controllers.UpdateUser)
    adminRoutes.DELETE("/users/:id", controllers.DeleteUser)

    // Reservation routes
    adminRoutes.POST("/reservations", controllers.CreateReservation)
    adminRoutes.GET("/reservations/:id", controllers.GetReservation)
    adminRoutes.PUT("/reservations/:id", controllers.UpdateReservation)
    adminRoutes.DELETE("/reservations/:id", controllers.DeleteReservation)

    // Chat routes
    adminRoutes.POST("/chat", controllers.CreateChat)
    adminRoutes.GET("/chat/:id", controllers.GetChat)
    adminRoutes.PUT("/chat/:id", controllers.UpdateChat)
    adminRoutes.DELETE("/chat/:id", controllers.DeleteChat)

    // Message routes
    adminRoutes.POST("/messages", controllers.CreateMessage)
    adminRoutes.GET("/messages/:id", controllers.GetMessage)
    adminRoutes.PUT("/messages/:id", controllers.UpdateMessage)
    adminRoutes.DELETE("/messages/:id", controllers.DeleteMessage)

    // Event routes
    adminRoutes.POST("/events", controllers.CreateEvent)
    adminRoutes.GET("/events/:id", controllers.GetEvent)
    adminRoutes.PUT("/events/:id", controllers.UpdateEvent)
    adminRoutes.DELETE("/events/:id", controllers.DeleteEvent)

    // Rate routes
    adminRoutes.POST("/rates", controllers.CreateRate)
    adminRoutes.GET("/rates/:id", controllers.GetRate)
    adminRoutes.PUT("/rates/:id", controllers.UpdateRate)
    adminRoutes.DELETE("/rates/:id", controllers.DeleteRate)

    // Organizer routes
    adminRoutes.POST("/organizers", controllers.CreateOrganizer)
    adminRoutes.GET("/organizers/:id", controllers.GetOrganizer)
    adminRoutes.PUT("/organizers/:id", controllers.UpdateOrganizer)
    adminRoutes.DELETE("/organizers/:id", controllers.DeleteOrganizer)

    // Notification routes
    adminRoutes.POST("/notifications", controllers.CreateNotification)
    adminRoutes.GET("/notifications/:id", controllers.GetNotification)
    adminRoutes.PUT("/notifications/:id", controllers.UpdateNotification)
    adminRoutes.DELETE("/notifications/:id", controllers.DeleteNotification)
}
