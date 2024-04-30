package fixtures

import (
	"easynight/internal/models"
)

var Organizers = []models.Organizer{
	{UserID: BaseOrganizers[0].ID, User: BaseOrganizers[0], Firstname: "Organizer", Lastname: "Test"},
	{UserID: BaseOrganizers[1].ID, User: BaseOrganizers[1], Firstname: "David", Lastname: "Guetta"},
	{UserID: BaseOrganizers[2].ID, User: BaseOrganizers[2], Firstname: "DJ", Lastname: "Snake"},
	{UserID: BaseOrganizers[3].ID, User: BaseOrganizers[3], Firstname: "Café", Lastname: "Oz"},
	{UserID: BaseOrganizers[4].ID, User: BaseOrganizers[4], Firstname: "La", Lastname: "Clairière"},
}
