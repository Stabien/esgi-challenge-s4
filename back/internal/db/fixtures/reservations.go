package fixtures

import (
	"easynight/internal/models"

	"github.com/google/uuid"
)

var Reservations = []models.Reservation{
	{ID: uuid.New(), CustomerID: Customers[0].UserID, Customer: Customers[0], EventID: Events[0].ID, Event: Events[0], Qrcode: "test"},
}
