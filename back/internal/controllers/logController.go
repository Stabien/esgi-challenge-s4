package controllers

import (
	"bufio"
	"log"
	"net/http"
	"os"

	"github.com/labstack/echo/v4"
)

func GetAllLogs(c echo.Context) error {
	// read app.log file in tmp/ and return logs
	file, err := os.Open("tmp/app.log")
	if err != nil {
		log.Println("Error: No file app.log find")
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	var logs []string
	for scanner.Scan() {
		logs = append(logs, scanner.Text())
	}

	reversedLogs := make([]string, len(logs))
	for i, j := 0, len(logs)-1; i < len(logs); i, j = i+1, j-1 {
		reversedLogs[i] = logs[j]
	}

	log.Println("Get all logs")

	return c.JSON(http.StatusOK, reversedLogs)
}
