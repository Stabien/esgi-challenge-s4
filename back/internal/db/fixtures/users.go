package fixtures

import (
	"easynight/internal/models"
	"easynight/pkg/utils"
)

var BaseAdmins = []models.User{{Email: "admin@test.fr", Password: "test"}}
var BaseCustomers = []models.User{
	{Email: "customer@test.fr", Password: "test"},
	{Email: "antoine.dupont@test.fr", Password: "test"},
	{Email: "gael.fickou@test.fr", Password: "test"},
	{Email: "damien.penaud@test.fr", Password: "test"},
	{Email: "romain.ntamack@test.fr", Password: "test"},
}

var BaseOrganizers = []models.User{
	{Email: "organizer@test.fr", Password: "test"},
	{Email: "david.guetta@test.fr", Password: "test"},
	{Email: "dj.snake@test.fr", Password: "test"},
	{Email: "cafe.oz@test.fr", Password: "test"},
	{Email: "la.clairiere@test.fr", Password: "test"},
}

var Users = utils.MergeSlices(BaseAdmins, BaseCustomers, BaseOrganizers)
