package fixtures

import (
	"easynight/internal/models"
	"easynight/pkg/utils"
)

// Base Users
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

var BaseUsers = utils.MergeSlices(BaseAdmins, BaseCustomers, BaseOrganizers)

// Users
var Admins = []models.Admin{{UserID: BaseAdmins[0].ID, User: BaseAdmins[0]}}

var Organizers = []models.Organizer{
	{UserID: BaseOrganizers[0].ID, User: BaseOrganizers[0], Firstname: "Organizer", Lastname: "Test"},
	{UserID: BaseOrganizers[1].ID, User: BaseOrganizers[1], Firstname: "David", Lastname: "Guetta"},
	{UserID: BaseOrganizers[2].ID, User: BaseOrganizers[2], Firstname: "DJ", Lastname: "Snake"},
	{UserID: BaseOrganizers[3].ID, User: BaseOrganizers[3], Firstname: "Café", Lastname: "Oz"},
	{UserID: BaseOrganizers[4].ID, User: BaseOrganizers[4], Firstname: "La", Lastname: "Clairière"},
}

var Customers = []models.Customer{
	{UserID: BaseCustomers[0].ID, User: BaseCustomers[0], Firstname: "Customer", Lastname: "Test"},
	{UserID: BaseCustomers[1].ID, User: BaseCustomers[1], Firstname: "Antoine", Lastname: "Dupont"},
	{UserID: BaseCustomers[2].ID, User: BaseCustomers[2], Firstname: "Gaël", Lastname: "Fickou"},
	{UserID: BaseCustomers[3].ID, User: BaseCustomers[3], Firstname: "Damien", Lastname: "Penaud"},
	{UserID: BaseCustomers[4].ID, User: BaseCustomers[4], Firstname: "Romain", Lastname: "Ntamack"},
}
