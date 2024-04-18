package fixtures

import "easynight/internal/models"

var Reservations = []models.Reservation{
	{CustomerID: Customers[0].UserID, Customer: Customers[0], EventID: Events[0].ID, Event: Events[0], Qrcode: "test"},
}
