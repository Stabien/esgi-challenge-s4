package main

import (
	_ "easynight/docs"
	"easynight/internal/db"
	"easynight/internal/routes"
	"easynight/internal/validators"
	"easynight/pkg/utils"
	"io"
	"log"
	"net/http"
	"os"

	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
)

func main() {
	e := echo.New()

	// TODO: voir pour externaliser la configuration
	file, err := os.OpenFile("tmp/app.log", os.O_CREATE|os.O_WRONLY|os.O_APPEND, 0666)
	if err != nil {
		log.Println("Error: when opening file app.log")
	}

	log.SetOutput(io.MultiWriter(os.Stdout, file))
	log.SetFlags(log.LstdFlags | log.Lmicroseconds)

	defer file.Close()
	// TODO end

	db.DatabaseInit()

	e.Use(middleware.Logger())
	e.Use(middleware.Recover())
	e.Use(middleware.CORSWithConfig(middleware.CORSConfig{
		AllowOrigins: []string{"*"},
	}))

	e.Static("/", "public")

	validators.InitValidators(e)
	routes.InitRouter(e)

	log.Fatal(http.ListenAndServe(":"+utils.GetEnvVariable("PORT"), e))
}
