package controllers

import (
	"easynight/internal/db"
	"easynight/internal/models"
	"encoding/json"
	"net/http"
	"strings"
)

func GetAllEvents(w http.ResponseWriter, r *http.Request) {
	var events []models.Event
	var nameFilter string = ""

	nameFilter = r.URL.Path[len("/events/"):]

	if nameFilter != "undefined" {
		nameFilter = "%" + strings.ToLower(nameFilter) + "%"
		if err := db.DB().Where("LOWER(title) LIKE ?", nameFilter).Find(&events).Error; err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
	} else {
		if err := db.DB().Find(&events).Error; err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
	}

	w.Header().Set("Content-Type", "application/json")
	if err := json.NewEncoder(w).Encode(events); err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
}
