package fixtures

import (
	"easynight/internal/models"

	"github.com/google/uuid"
)

var Features = []models.FeatureFlipping{
	{
		ID:        uuid.New(),
		Name:      "event_create",
		IsEnabled: true,
	},
	{
		ID:        uuid.New(),
		Name:      "event_update",
		IsEnabled: true,
	},
	{
		ID:        uuid.New(),
		Name:      "event_delete",
		IsEnabled: true,
	},
}
