package db

import (
	"easynight/internal/models"
	"easynight/pkg/utils"
	"fmt"
	"log"

	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

var database *gorm.DB
var err error

func makeMigration(database *gorm.DB) error {
	return database.AutoMigrate(
		&models.User{},
		&models.Admin{},
		&models.Customer{},
		&models.Event{},
		&models.EventPhoto{},
		&models.Message{},
		&models.Notification{},
		&models.Organizer{},
		&models.Rate{},
		&models.Reservation{},
	)
}

func DatabaseInit() {
	host := utils.GetEnvVariable("DB_HOST")
	user := utils.GetEnvVariable("DB_USERNAME")
	password := utils.GetEnvVariable("DB_PASSWORD")
	dbName := utils.GetEnvVariable("DB_NAME")
	port := utils.GetEnvVariable("DB_PORT")

	dsn := fmt.Sprintf("host=%s user=%s password=%s dbname=%s port=%s sslmode=disable", host, user, password, dbName, port)
	database, err = gorm.Open(postgres.Open(dsn), &gorm.Config{})

	if err != nil {
		log.Fatal(err)
	}

	err = makeMigration(database)

	if err != nil {
		log.Fatal(err)
	}

	InitFixtures(database)

	dbGorm, err := database.DB()

	if err != nil {
		panic(err)
	}

	dbGorm.Ping()
}

func DB() *gorm.DB {
	return database
}
