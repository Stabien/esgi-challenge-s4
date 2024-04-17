package main

import (
	"easynight/internal/controllers"
	"easynight/internal/db"
	"easynight/internal/models"
	"fmt"
	"io"
	"log"
	"net/http"
	"strings"

	"github.com/labstack/echo/v4"
	"github.com/zc2638/swag"
	"github.com/zc2638/swag/endpoint"
	"github.com/zc2638/swag/option"
)

func handle(w http.ResponseWriter, r *http.Request) {
	_, _ = io.WriteString(w, fmt.Sprintf("[%s]", r.Method))
}

func main() {
	api := swag.New(
		option.Title("API Doc EsayNight"),
	)

	api.AddEndpoint(
		endpoint.New(
			http.MethodPost, "/suscribe",
			endpoint.Handler(controllers.HelloHandle),
			endpoint.Summary("Create user"),
			endpoint.Description("Create a acount for the user"),
			endpoint.Body(models.User{}, "User object that needs to be create", true),
			endpoint.Response(http.StatusOK, "Successfully user create", endpoint.SchemaResponseOption(models.User{})),
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

	router.POST("/event", controllers.CreateEvent)
	router.PATCH("/event/:id", controllers.UpdateEvent)

	// routes.InitRouter(router)

	// log.Fatal(http.ListenAndServe(":"+utils.GetEnvVariable("PORT"), router))
	log.Fatal(http.ListenAndServe(":3000", router))
}
