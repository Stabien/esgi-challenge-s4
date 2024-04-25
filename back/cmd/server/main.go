package main

import (
	_ "easynight/docs"
	"easynight/internal/db"
	"easynight/internal/routes"
	"easynight/pkg/utils"
	"log"
	"net/http"

	"github.com/labstack/echo/v4"
	echoSwagger "github.com/swaggo/echo-swagger"
)

// @title			Swagger Example API
// @version		1.0
// @description	This is a sample server for using Swagger with Echo.
// @host			localhost:3000
// @BasePath		/api/v1
func main() {
	router := echo.New()

	db.DatabaseInit()

	router.GET("/swagger/*", echoSwagger.WrapHandler)

	routes.InitRouter(router)

	log.Fatal(http.ListenAndServe(":"+utils.GetEnvVariable("PORT"), router))
}
