package main

import (
	"easynight/internal/db"
	"easynight/internal/fixtures"
	"fmt"
	"log"
)

func main() {
	database, err := db.OpenDB()

	if err != nil {
		log.Fatal(err)
	}

	fixtures.LoadFixtures(database)

	fmt.Print("Fixtures loaded !")
}
