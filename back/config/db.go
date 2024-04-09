package config

import (
	"echoApi/utils"
	"fmt"

	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

var database *gorm.DB
var e error

func DatabaseInit() {
	host := utils.GoDotEnvVariable("DB_HOST")
	user := utils.GoDotEnvVariable("DB_USERNAME")
	password := utils.GoDotEnvVariable("DB_PASSWORD")
	dbName := utils.GoDotEnvVariable("DB_NAME")
	port := utils.GoDotEnvVariable("DB_PORT")

	dsn := fmt.Sprintf("host=%s user=%s password=%s dbname=%s port=%s sslmode=disable", host, user, password, dbName, port)
	database, e = gorm.Open(postgres.Open(dsn), &gorm.Config{})

	if e != nil { 
		panic(e)
	}

	dbGorm, err := database.DB()
	
	if err != nil {
		panic(err)
	}

	dbGorm.Ping()
}

func DB() *gorm.DB {
	return database
}