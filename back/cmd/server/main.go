package main

import (
	_ "easynight/docs"
	"easynight/internal/db"
	"easynight/internal/routes"
	"easynight/internal/validators"
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
// @BasePath		/
func main() {
	e := echo.New()

	db.DatabaseInit()

	e.GET("/swagger/*", echoSwagger.WrapHandler)

	validators.InitValidators(e)
	routes.InitRouter(e)

	log.Fatal(http.ListenAndServe(":"+utils.GetEnvVariable("PORT"), e))
}
