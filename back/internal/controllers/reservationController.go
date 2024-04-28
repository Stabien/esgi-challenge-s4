package controllers

import (
	"easynight/internal/db"
	"easynight/internal/models"
	"easynight/pkg/utils"
	"encoding/json"
	"fmt"
	"net/http"

	"github.com/google/uuid"
)

func PostReservation(w http.ResponseWriter, r *http.Request) {
	var reservation models.Reservation

	err := json.NewDecoder(r.Body).Decode(&reservation)
	if err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	if reservation.EventID == uuid.Nil {
		http.Error(w, "EventID is required", http.StatusBadRequest)
		return
	}

	qr, _ := utils.GenerateQRCode()
	fmt.Println(qr)
	// reservation.Qrcode = string(qr)

	if err := db.DB().Create(&reservation).Error; err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	reservationJSON, err := json.Marshal(reservation)
	if err != nil {
		http.Error(w, "Error encoding reservation", http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusCreated)
	w.Write(reservationJSON)
}
