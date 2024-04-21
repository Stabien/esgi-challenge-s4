package fixtures

import (
	"easynight/internal/db"
	"log"

	"github.com/spf13/cobra"
	"gorm.io/gorm"
)

var AllFixtures = []any{
	Users,
	Admins,
	Organizers,
	Customers,
	Events,
	Reservations,
}

func loadFixtures(db *gorm.DB) {
	for _, fixture := range AllFixtures {
		result := db.Create(fixture)

		if result.Error != nil {
			log.Fatal(result.Error)
		}
	}
}

func loadFixturesCommand(cmd *cobra.Command, args []string) {
	loadFixtures(db.DB())
}

var FixturesCmd = &cobra.Command{
	Use:   "fixtures",
	Short: "Load fixtures into the database",
	Run:   loadFixturesCommand,
}
