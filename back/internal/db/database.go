package db

import (
	"easynight/internal/models"
	"easynight/pkg/utils"
	"fmt"

	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

var database *gorm.DB
var e error

func DatabaseInit() {
	host := utils.GetEnvVariable("DB_HOST")
	user := utils.GetEnvVariable("DB_USERNAME")
	password := utils.GetEnvVariable("DB_PASSWORD")
	dbName := utils.GetEnvVariable("DB_NAME")
	port := utils.GetEnvVariable("DB_PORT")

	dsn := fmt.Sprintf("host=%s user=%s password=%s dbname=%s port=%s sslmode=disable", host, user, password, dbName, port)
	database, e = gorm.Open(postgres.Open(dsn), &gorm.Config{})

	if e != nil { 
		panic(e)
	}

	database.AutoMigrate(&models.User{}, &models.Admin{})

	dbGorm, err := database.DB()
	
	if err != nil {
		panic(err)
	}

	dbGorm.Ping()
}

func DB() *gorm.DB {
	return database
}