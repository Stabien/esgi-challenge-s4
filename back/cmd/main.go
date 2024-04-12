package main

import (
	"easynight/internal/db"
	"log"
	"net/http"
	"strings"

	"github.com/labstack/echo/v4"
	"github.com/zc2638/swag"
	"github.com/zc2638/swag/option"
)

func main() {
	api := swag.New(
		option.Title("API Doc EsayNight"),
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

	// log.Fatal(http.ListenAndServe(":"+utils.GetEnvVariable("PORT"), router))
	log.Fatal(http.ListenAndServe(":3000", router))
}
