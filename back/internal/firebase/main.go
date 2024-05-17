package firebase

import (
	"context"
	"easynight/pkg/utils"
	"log"
	"os"

	"golang.org/x/oauth2/google"
)

func GetAccessToken() (string, error) {
	ctx := context.Background()

	// Load json file containing credentials
	keyFile := "./internal/firebase/" + utils.GetEnvVariable("FIREBASE_KEY_FILE")
	jsonKey, err := os.ReadFile(keyFile)

	if err != nil {
		log.Println(err)
		return "", err
	}

	// Retrieve a JWT configuration from the JSON key file
	conf, err := google.JWTConfigFromJSON(jsonKey, "https://www.googleapis.com/auth/cloud-platform")
	if err != nil {
		log.Println(err)
		return "", err
	}

	// Create a JWT token source using the configuration
	tokenSource := conf.TokenSource(ctx)

	// Retrieve a token from the token source
	token, err := tokenSource.Token()
	if err != nil {
		log.Println(err)
		return "", err
	}

	return token.AccessToken, nil
}
