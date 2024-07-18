package fixtures

import (
	"easynight/internal/models"

	"github.com/google/uuid"
)

var Tags = []models.Tag{
	{ID: uuid.New(), Name: "Disco"},
	{ID: uuid.New(), Name: "Jazz"},
	{ID: uuid.New(), Name: "Techno"},
	{ID: uuid.New(), Name: "Rock"},
}
