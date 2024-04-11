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

func MergeSlices[T any](slices ...[]T) []T {
	var mergedSlice []T

	for _, slice := range slices {
		mergedSlice = append(mergedSlice, slice...)
	}

	return mergedSlice
}

func ForEach[T any, S any](slice []T, transform func(element T) S) []S {
	var newSlice []S
	
	for _, element := range slice {
		newElement := transform(element)
		newSlice = append(newSlice, newElement)
	}

	return newSlice
}
