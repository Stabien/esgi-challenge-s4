package main

import (
	_ "easynight/docs"

	"easynight/internal/controllers"

	"github.com/gin-gonic/gin"
	swaggerFiles "github.com/swaggo/files"
	ginSwagger "github.com/swaggo/gin-swagger"
)

func main() {

	r := gin.Default()

	c := controllers.NewController()

	v1 := r.Group("/api/v1")
	{
		accounts := v1.Group("/accounts")
		{
			accounts.GET(":id", c.ShowAccount)

		}
	}
	r.GET("/swagger/*any", ginSwagger.WrapHandler(swaggerFiles.Handler))
	r.Run(":3000")

	// e := echo.New()

	// db.DatabaseInit()

	// routes.InitRouter(e)

	// e.Logger.Fatal(e.Start(":" + utils.GetEnvVariable("PORT")))
}
