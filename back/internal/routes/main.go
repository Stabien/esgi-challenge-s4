package routes

import (
	"easynight/internal/controllers"
	"easynight/internal/ws"

	"github.com/labstack/echo/v4"
	echoSwagger "github.com/swaggo/echo-swagger"
)

func InitRouter(e *echo.Echo) {
	e.GET("/swagger/*", echoSwagger.WrapHandler)

	// e.GET("/ws", ws.HandleWebSocket)
	e.GET("/ws/room", ws.HandleRoomWebSocket)

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
	e.GET("/reservations/isValid/:reservationId", controllers.IsValid)

	e.POST("/reservations", controllers.PostReservation)
	e.DELETE("/reservations", controllers.DeleteReservation)
	e.GET("/reservations/:customerId", controllers.GetReservationsbyUser)

	e.POST("/auth", controllers.Authentication)
	e.POST("/customers", controllers.CustomerRegistration)
	e.POST("/organizers", controllers.OrganizerRegistration)
	// e.GET("/role", controllers.GetRole)
	e.GET("/users/custom/:id", controllers.GetUserByIdCustomer)
	e.GET("/users/orga/:id", controllers.GetUserByIdOrga)
	e.PATCH("/users/orga/:id", controllers.UpdateUserByIdOrga)
	e.PATCH("/users/custom/:id", controllers.UpdateUserByIdCustomer)

	e.POST("/send-notification", controllers.SendNotification)
	e.GET("/logs", controllers.GetAllLogs) // TODO: add middleware to check if user is admin

	// Admin
	// Groupes de routes protégées par le middleware CheckAdminMiddleware
	// adminRoutes := authRoutes.Group("/admin")
	// adminRoutes.Use(middlewares.CheckAdminMiddleware)

	// User routes
	e.POST("/users", controllers.CreateUser)
	e.GET("/users/:id", controllers.GetUser)
	e.PUT("/users/:id", controllers.UpdateUser)
	e.DELETE("/users/:id", controllers.DeleteUser)
	// Forgot password
	e.POST("/send-mail-forgot-password", controllers.SendMailForgotPassword)
	e.POST("/forgot-password", controllers.ForgotPassword)

	// Reservation routes
	e.POST("/reservations", controllers.PostReservation)
	// e.GET("/reservations/:id", controllers.GetReservation)
	e.PUT("/reservations/:id", controllers.UpdateReservation)
	e.DELETE("/reservations/:id", controllers.DeleteReservation)

	// Chat routes
	e.POST("/chat", controllers.CreateChat)
	e.GET("/chat/:id", controllers.GetChat)
	e.PUT("/chat/:id", controllers.UpdateChat)
	e.DELETE("/chat/:id", controllers.DeleteChat)

	// Message routes
	e.POST("/messages", controllers.CreateMessage)
	e.GET("/messages/:id", controllers.GetMessage)
	e.PUT("/messages/:id", controllers.UpdateMessage)
	e.DELETE("/messages/:id", controllers.DeleteMessage)

	// Event routes
	e.POST("/events", controllers.CreateEvent)
	e.GET("/events/:id", controllers.GetEvent)
	e.PUT("/events/:id", controllers.UpdateEvent)
	e.DELETE("/events/:id", controllers.DeleteEvent)

	// Rate routes
	e.POST("/rates", controllers.CreateRate)
	e.GET("/rates/:id", controllers.GetRate)
	e.GET("/rates/:id", controllers.GetAllRates)
	e.PUT("/rates/:id", controllers.UpdateRate)
	e.DELETE("/rates/:id", controllers.DeleteRate)

	// Organizer routes
	e.POST("/organizers", controllers.CreateOrganizer)
	e.GET("/organizers/:id", controllers.GetOrganizer)
	e.GET("/organizers/:id", controllers.GetAllOrganizers)
	e.PUT("/organizers/:id", controllers.UpdateOrganizer)
	e.DELETE("/organizers/:id", controllers.DeleteOrganizer)

	// Notification routes
	e.POST("/notifications", controllers.CreateNotification)
	e.GET("/notifications/:id", controllers.GetNotification)
	e.GET("/notifications/:id", controllers.GetAllNotifications)
	e.PUT("/notifications/:id", controllers.UpdateNotification)
	e.DELETE("/notifications/:id", controllers.DeleteNotification)
}
