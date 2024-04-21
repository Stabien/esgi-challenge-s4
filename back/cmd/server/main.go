package main

import (
	"easynight/internal/controllers"
	"easynight/internal/db"
	"easynight/internal/models"
	"easynight/internal/routes"
	"easynight/pkg/utils"
	"log"
	"net/http"
	"strings"

	"github.com/labstack/echo/v4"
	"github.com/zc2638/swag"
	"github.com/zc2638/swag/endpoint"
	"github.com/zc2638/swag/option"
)

func main() {
	api := swag.New(
		option.Title("API Doc EsayNight"),
	)

	api.AddEndpoint(
		endpoint.New(
			http.MethodGet, "/events/{title}",
			endpoint.Handler(controllers.GetAllEvents),
			endpoint.Path("title", "string", "filter title", false),
			endpoint.Summary("Get all events"),
			endpoint.Description("all event that are available"),
			endpoint.Response(http.StatusOK, "events", endpoint.SchemaResponseOption(models.Event{})),

			// endpoint.Security("petstore_auth", "read:pets", "write:pets"),
		),
	)

	api.AddEndpoint(
		endpoint.New(
			http.MethodPost, "/reservations",
			endpoint.Handler(controllers.PostReservation),
			endpoint.Body(models.Reservation{}, "application/json", true),
			endpoint.Summary("Get all events"),
			endpoint.Description("all event that are available"),
			endpoint.Response(http.StatusOK, "events", endpoint.SchemaResponseOption(models.Event{})),
			// endpoint.Security("petstore_auth", "read:pets", "write:pets"),
		),
	)

	router := echo.New()
	db.DatabaseInit()

	api.Walk(func(path string, e *swag.Endpoint) {
		h := echo.WrapHandler(e.Handler.(http.Handler))
		path = swag.ColonPath(path)

		switch strings.ToLower(e.Method) {
		case "get":
			router.GET(path, h)
		case "head":
			router.HEAD(path, h)
		case "options":
			router.OPTIONS(path, h)
		case "delete":
			router.DELETE(path, h)
		case "put":
			router.PUT(path, h)
		case "post":
			router.POST(path, h)
		case "trace":
			router.TRACE(path, h)
		case "patch":
			router.PATCH(path, h)
		case "connect":
			router.CONNECT(path, h)
		}
	})

	router.GET("/swagger/json", echo.WrapHandler(api.Handler()))
	router.GET("/swagger/ui/*", echo.WrapHandler(swag.UIHandler("/swagger/ui", "/swagger/json", true)))

	routes.InitRouter(router)

	log.Fatal(http.ListenAndServe(":"+utils.GetEnvVariable("PORT"), router))
}
