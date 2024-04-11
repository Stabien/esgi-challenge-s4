package db

import (
	"easynight/internal/models"
	"easynight/pkg/utils"

	"gorm.io/gorm"
)

func usersFixtures(db *gorm.DB) {

}

func InitFixtures(db *gorm.DB) {
	baseAdmins := []models.User{{Email: "admin@test.fr", Password: "test"}}
	baseCustomers := []models.User{
		{Email: "customer@test.fr", Password: "test"},
		{Email: "antoine.dupont@test.fr", Password: "test"},
		{Email: "gael.fickou@test.fr", Password: "test"},
		{Email: "damien.penaud@test.fr", Password: "test"},
		{Email: "romain.ntamack@test.fr", Password: "test"},
	}
	baseOrganizer := []models.User{
		{Email: "organizer@test.fr", Password: "test"},
		{Email: "david.guetta@test.fr", Password: "test"},
		{Email: "dj.snake@test.fr", Password: "test"},
		{Email: "cafe.oz@test.fr", Password: "test"},
		{Email: "la.clairiere@test.fr", Password: "test"},
	}

	baseUsers := utils.MergeSlice[models.User](baseAdmins, baseCustomers, baseOrganizer)

	// customer := models.Customer{User: baseUsers[0], UserID: baseUsers[0].ID}
	// organizer := models.Organizer{User: baseUsers[1], UserID: baseUsers[1].ID}
	// admin := models.Admin{User: baseUsers[2], UserID: baseUsers[2].ID}

	db.Create(&baseUsers)
}
