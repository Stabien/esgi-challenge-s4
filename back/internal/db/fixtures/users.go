package fixtures

import (
	"easynight/internal/models"
	"easynight/pkg/utils"

	"github.com/google/uuid"
)

var BaseAdmins = []models.User{{ID: uuid.New(), Email: "admin@test.fr", Password: "test"}}
var BaseCustomers = []models.User{
	{ID: uuid.New(), Email: "customer@test.fr", Password: "test"},
	{ID: uuid.New(), Email: "antoine.dupont@test.fr", Password: "test"},
	{ID: uuid.New(), Email: "gael.fickou@test.fr", Password: "test"},
	{ID: uuid.New(), Email: "damien.penaud@test.fr", Password: "test"},
	{ID: uuid.New(), Email: "romain.ntamack@test.fr", Password: "test"},
}

var BaseOrganizers = []models.User{
	{ID: uuid.New(), Email: "organizer@test.fr", Password: "test"},
	{ID: uuid.New(), Email: "david.guetta@test.fr", Password: "test"},
	{ID: uuid.New(), Email: "dj.snake@test.fr", Password: "test"},
	{ID: uuid.New(), Email: "cafe.oz@test.fr", Password: "test"},
	{ID: uuid.New(), Email: "la.clairiere@test.fr", Password: "test"},
}

var Users = utils.MergeSlices(BaseAdmins, BaseCustomers, BaseOrganizers)
