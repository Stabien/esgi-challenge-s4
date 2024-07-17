package fixtures

import (
	"easynight/internal/models"

	"github.com/google/uuid"
)

var Organizers = []models.Organizer{
	{ID: uuid.New(), UserID: BaseOrganizers[0].ID, User: BaseOrganizers[0], Firstname: "Organizer", Lastname: "Test"},
	{ID: uuid.New(), UserID: BaseOrganizers[1].ID, User: BaseOrganizers[1], Firstname: "David", Lastname: "Guetta"},
	{ID: uuid.New(), UserID: BaseOrganizers[2].ID, User: BaseOrganizers[2], Firstname: "DJ", Lastname: "Snake"},
	{ID: uuid.New(), UserID: BaseOrganizers[3].ID, User: BaseOrganizers[3], Firstname: "Café", Lastname: "Oz"},
	{ID: uuid.New(), UserID: BaseOrganizers[4].ID, User: BaseOrganizers[4], Firstname: "La", Lastname: "Clairière"},
}
