package utils

import (
	"log"
	"os"

	"github.com/joho/godotenv"
)

func GetEnvVariable(key string) string {

	// load .env file
	err := godotenv.Load(".env.local")

	if err != nil {
		log.Fatalf("Error loading .env file")
	}

	return os.Getenv(key)
}

func MergeSlice[T any](slices ...[]T) []T {
	var mergedSlice []T

	for _, slice := range slices {
		mergedSlice = append(mergedSlice, slice...)
	}

	return mergedSlice
}
