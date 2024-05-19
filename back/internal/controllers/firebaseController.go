package controllers

import (
	"bytes"
	"encoding/json"
	"log"
	"net/http"
	"time"

	"easynight/internal/firebase"

	"github.com/labstack/echo/v4"
)

// @Summary Send a notification using Firebase Cloud Messaging
// @Tags Notification
// @Accept json
// @Produce json
// @Success 200 {string} string "Notification sent successfully"
// @Failure 400 {object} error "Bad request"
// @Failure 500 {object} error "Internal server error"
// @Router /send-notification [post]
func SendNotification(c echo.Context) error {
	// Firebase Cloud Messaging endpoint URL
	url := "https://fcm.googleapis.com/v1/projects/challenges4notification/messages:send"

	// Prepare message data
	message := map[string]interface{}{
		"message": map[string]interface{}{
			"token": "eOVXJp-RQjmiabK7cT9Hi6:APA91bHqopkR-maI79mQzT2jpEY7Z4p4ca4cAfk369q8utwJM_CmEY5nADWkBcHCUplyCgN4XKbT6a0AE6GWgPrQgpsHAOptefbz-LPOiwCogXe0VR6hGDYJTdiza5HHF3-af5yTDvu-",
			"notification": map[string]interface{}{
				"body":  "Découvrez nos nouveaux événements!",
				"title": "Bienvenue sur notre application",
				"image": "https://picsum.photos/300/300",
			},
		},
	}

	// Serialize message data to JSON
	requestData, err := json.Marshal(message)
	if err != nil {
		log.Println(err)
		return err
	}

	// Create HTTP request
	req, err := http.NewRequest("POST", url, bytes.NewBuffer(requestData))
	if err != nil {
		log.Println(err)
		return err
	}

	token, err := firebase.GetAccessToken()
	if err != nil {
		log.Println(err)
		return err
	}

	// Set headers
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Authorization", "Bearer "+token)

	// Create HTTP client with timeout
	client := &http.Client{
		Timeout: time.Second * 10,
	}

	// Send HTTP request
	resp, err := client.Do(req)
	if err != nil {
		log.Println(err)
		return err
	}
	defer resp.Body.Close()

	// Check response status code
	if resp.StatusCode != http.StatusOK {
		return echo.NewHTTPError(resp.StatusCode, "Failed to send notification")
	}

	log.Println("Notification sent successfully")

	return c.String(http.StatusOK, "Notification sent successfully")
}
