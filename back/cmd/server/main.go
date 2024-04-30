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
	"github.com/labstack/echo/v4/middleware"
)

// @title			Swagger Example API
// @version		1.0
// @description	This is a sample server for using Swagger with Echo.
// @host			localhost:3000
// @BasePath		/
func main() {
	e := echo.New()

	db.DatabaseInit()

	e.Use(middleware.Logger())
	e.Use(middleware.Recover())

	validators.InitValidators(e)
	routes.InitRouter(e)

	log.Fatal(http.ListenAndServe(":"+utils.GetEnvVariable("PORT"), e))
}
