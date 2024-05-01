package fixtures

import (
	"easynight/internal/models"
	"easynight/pkg/utils"
	"log"

	"github.com/google/uuid"
)

func getDefaultPassword() string {
	password, err := utils.HashPassword("test")

	if err != nil {
		log.Fatal(err)
	}

	return password
}

var BaseAdmins = []models.User{{ID: uuid.New(), Email: "admin@test.fr", Password: getDefaultPassword()}}
var BaseCustomers = []models.User{
	{ID: uuid.New(), Email: "customer@test.fr", Password: getDefaultPassword()},
	{ID: uuid.New(), Email: "antoine.dupont@test.fr", Password: getDefaultPassword()},
	{ID: uuid.New(), Email: "gael.fickou@test.fr", Password: getDefaultPassword()},
	{ID: uuid.New(), Email: "damien.penaud@test.fr", Password: getDefaultPassword()},
	{ID: uuid.New(), Email: "romain.ntamack@test.fr", Password: getDefaultPassword()},
}

var BaseOrganizers = []models.User{
	{ID: uuid.New(), Email: "organizer@test.fr", Password: getDefaultPassword()},
	{ID: uuid.New(), Email: "david.guetta@test.fr", Password: getDefaultPassword()},
	{ID: uuid.New(), Email: "dj.snake@test.fr", Password: getDefaultPassword()},
	{ID: uuid.New(), Email: "cafe.oz@test.fr", Password: getDefaultPassword()},
	{ID: uuid.New(), Email: "la.clairiere@test.fr", Password: getDefaultPassword()},
}

var Users = utils.MergeSlices(BaseAdmins, BaseCustomers, BaseOrganizers)
