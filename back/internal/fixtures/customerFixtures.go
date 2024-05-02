package fixtures

import "easynight/internal/models"

var Customers = []models.Customer{
	{UserID: BaseCustomers[0].ID, User: BaseCustomers[0], Firstname: "Customer", Lastname: "Test"},
	{UserID: BaseCustomers[1].ID, User: BaseCustomers[1], Firstname: "Antoine", Lastname: "Dupont"},
	{UserID: BaseCustomers[2].ID, User: BaseCustomers[2], Firstname: "Gaël", Lastname: "Fickou"},
	{UserID: BaseCustomers[3].ID, User: BaseCustomers[3], Firstname: "Damien", Lastname: "Penaud"},
	{UserID: BaseCustomers[4].ID, User: BaseCustomers[4], Firstname: "Romain", Lastname: "Ntamack"},
}
