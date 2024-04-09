package main

import (
	"easynight/internal/db"
	"easynight/internal/routes"
	"easynight/pkg/utils"

	"github.com/labstack/echo/v4"
)

func main() {
	e := echo.New()

	db.DatabaseInit()

	routes.InitRouter(e)

	e.Logger.Fatal(e.Start(":" + utils.GetEnvVariable("PORT")))
}