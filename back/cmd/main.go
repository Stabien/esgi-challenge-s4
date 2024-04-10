package main

import (
	"fmt"
	"io"
	"log"
	"net/http"
	"strings"

	"github.com/zc2638/swag"
	"github.com/zc2638/swag/api"

	"github.com/labstack/echo/v4"
)

type Category struct {
	ID     int64  `json:"category"`
	Name   string `json:"name" enum:"dog,cat" required:""`
	Exists *bool  `json:"exists" required:""`
}

// Pet example from the swagger pet store
type Pet struct {
	ID        int64     `json:"id"`
	Category  *Category `json:"category" desc:"分类"`
	Name      string    `json:"name" required:"" example:"张三" desc:"名称"`
	PhotoUrls []string  `json:"photoUrls"`
	Tags      []string  `json:"tags" desc:"标签"`
}

func handle(w http.ResponseWriter, r *http.Request) {
	_, _ = io.WriteString(w, fmt.Sprintf("[%s] Hello World!", r.Method))
}

func main() {
	router := echo.New()

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

	router.GET("/swagger/json", echo.WrapHandler(swag.HandlerWrap()))
	router.GET("/swagger/ui/*", echo.WrapHandler(swag.UIHandler("/swagger/ui", "/swagger/json", true)))

	log.Fatal(http.ListenAndServe(":8080", router))
}
