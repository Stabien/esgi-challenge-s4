package main

import (
	"easynight/internal/db/fixtures"
	"easynight/pkg/utils"
	"fmt"
	"log"

	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

func main() {
	host := utils.GetEnvVariable("DB_HOST")
	user := utils.GetEnvVariable("DB_USERNAME")
	password := utils.GetEnvVariable("DB_PASSWORD")
	dbName := utils.GetEnvVariable("DB_NAME")
	port := utils.GetEnvVariable("DB_PORT")

	dsn := fmt.Sprintf("host=%s user=%s password=%s dbname=%s port=%s sslmode=disable", host, user, password, dbName, port)
	database, err := gorm.Open(postgres.Open(dsn), &gorm.Config{})

	if err != nil {
		log.Fatal(err)
	}

	fixtures.LoadFixtures(database)
}
