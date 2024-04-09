package main

import (
	"echoApi/config"
	"echoApi/routes"
	"echoApi/utils"

	"github.com/labstack/echo/v4"
)

func main() {
	e := echo.New()

	config.DatabaseInit()

	routes.InitRouter(e)

	e.Logger.Fatal(e.Start(":" + utils.GoDotEnvVariable("PORT")))
}

