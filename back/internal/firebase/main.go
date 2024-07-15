package firebase

import (
	"context"
	"fmt"
	"log"

	firebase "firebase.google.com/go"
	"firebase.google.com/go/messaging"
	"google.golang.org/api/option"
)

func InitFirebaseApp() (*firebase.App, error) {
	credentialsPath := "./account_key.json"

	opt := option.WithCredentialsFile(credentialsPath)
	config := &firebase.Config{ProjectID: "challenges4notification"}
	app, err := firebase.NewApp(context.Background(), config, opt)
	if err != nil {
		return nil, fmt.Errorf("error initializing app: %v", err)
	}

	return app, nil
}

func SendNotificationToTopic() error {
	app, err := InitFirebaseApp()
	if err != nil {
		return err
	}

	ctx := context.Background()
	client, err := app.Messaging(ctx)
	if err != nil {
		log.Fatalf("error getting Messaging client: %v\n", err)
	}

	message := &messaging.Message{
		Topic: "test",
		Notification: &messaging.Notification{
			Title: "FCM Message",
			Body:  "This is an FCM Message",
		},
	}

	response, err := client.Send(context.Background(), message)
	if err != nil {
		return fmt.Errorf("error sending message: %v", err)
	}
	fmt.Println("Successfully sent message:", response)

	return nil
}
