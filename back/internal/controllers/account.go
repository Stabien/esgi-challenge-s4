package controllers

import (
	"fmt"
	"net/http"
	"strconv"

	"easynight/internal/httputil"

	"github.com/gin-gonic/gin"
)

func (c *Controller) ShowAccount(ctx *gin.Context) {
	id := ctx.Param("id")
	_, err := strconv.Atoi(id)
	if err != nil {
		httputil.NewError(ctx, http.StatusBadRequest, err)
		return
	}
	fmt.Println("id", id)
	ctx.JSON(http.StatusOK, "ok")
}
