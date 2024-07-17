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

func migrate(database *gorm.DB) error {
	return database.AutoMigrate(
		&models.User{},
		&models.Admin{},
		&models.Customer{},
		&models.Event{},
		&models.Message{},
		&models.Notification{},
		&models.Organizer{},
		&models.Rate{},
		&models.Reservation{},
		&models.FeatureFlipping{},
		&models.Tag{},
	)
}

func OpenDB() (*gorm.DB, error) {
	host := utils.GetEnvVariable("DB_HOST")
	user := utils.GetEnvVariable("DB_USERNAME")
	password := utils.GetEnvVariable("DB_PASSWORD")
	dbName := utils.GetEnvVariable("DB_NAME")
	port := utils.GetEnvVariable("DB_PORT")

	dsn := fmt.Sprintf("host=%s user=%s password=%s dbname=%s port=%s sslmode=disable", host, user, password, dbName, port)
	database, err = gorm.Open(postgres.Open(dsn), &gorm.Config{})

	return database, err
}

func DatabaseInit() {
	database, err = OpenDB()

	if err != nil {
		log.Fatal(err)
	} else {
		log.Println("Database connected")
	}

	err = migrate(database)

	if err != nil {
		log.Fatal(err)
	} else {
		log.Println("Database migrated")
	}

	dbGorm, err := database.DB()

	if err != nil {
		log.Fatal(err)
	}

	dbGorm.Ping()
}

func DB() *gorm.DB {
	return database
}
