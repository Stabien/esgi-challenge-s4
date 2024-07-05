package ws

import (
	"encoding/json"
	"log"
	"net/http"
	"time"

	"github.com/google/uuid"
	"github.com/gorilla/websocket"
	"github.com/labstack/echo/v4"
)

var upgrader = websocket.Upgrader{
	ReadBufferSize:  1024,
	WriteBufferSize: 1024,
	CheckOrigin: func(r *http.Request) bool {
		return true
	},
}

type Room struct {
	Name        string
	Connections map[string]*websocket.Conn
}

var activeRooms = make(map[string]*Room)

var activeConnections = make(map[string]*websocket.Conn)

type Message struct {
	Sender string    `json:"sender"`
	Date   time.Time `json:"date"`
	Text   string    `json:"text"`
}

func HandleRoomWebSocket(c echo.Context) error {
	roomName := c.QueryParam("roomName")

	// Vérifier si la room existe déjà, sinon la créer
	room, ok := activeRooms[roomName]
	if !ok {
		room = &Room{
			Name:        roomName,
			Connections: make(map[string]*websocket.Conn),
		}
		activeRooms[roomName] = room
	}

	// Upgrade de la connexion WebSocket
	ws, err := upgrader.Upgrade(c.Response(), c.Request(), nil)
	if err != nil {
		log.Println("Upgrade error:", err)
		return err
	}
	defer ws.Close()

	// Gérer la connexion dans la room
	connectionID := "connection-" + uuid.New().String()
	room.Connections[connectionID] = ws
	defer delete(room.Connections, connectionID)

	// Envoyer la liste des personnes connectées à tous les clients dans la room
	sendConnectedClients(room)

	// Boucle de lecture et d'écriture des messages
	for {
		// Lire le message JSON du client
		var clientMessage Message
		messageType, p, err := ws.ReadMessage()
		if err != nil {
			log.Println("Read error:", err)
			break
		}

		// Décoder le message JSON du client
		if err := json.Unmarshal(p, &clientMessage); err != nil {
			log.Println("JSON unmarshal error:", err)
			continue
		}

		// Vérifier si le champ `sender` est vide dans le message reçu
		if clientMessage.Sender == "" {
			clientMessage.Sender = connectionID // Utiliser `connectionID` comme nom par défaut si `sender` est vide
		}

		// Ajouter la date actuelle au message
		clientMessage.Date = time.Now()

		// Convertir le message en JSON
		messageJSON, err := json.Marshal(clientMessage)
		if err != nil {
			log.Println("JSON marshal error:", err)
			continue
		}

		// Diffuser le message à tous les autres clients dans la room
		for id, conn := range room.Connections {
			if id != connectionID {
				if err := conn.WriteMessage(messageType, messageJSON); err != nil {
					log.Println("Write error:", err)
					break
				}
			}
		}
	}

	return nil
}

func sendConnectedClients(room *Room) {
	// Construire la liste des clients connectés
	var connectedClients []string
	for id := range room.Connections {
		connectedClients = append(connectedClients, id)
	}

	// Convertir la liste en JSON
	clientsJSON, err := json.Marshal(connectedClients)
	if err != nil {
		log.Println("JSON marshal error:", err)
		return
	}

	// Envoyer le message à tous les clients dans la room
	for _, conn := range room.Connections {
		if err := conn.WriteMessage(websocket.TextMessage, clientsJSON); err != nil {
			log.Println("Write error:", err)
			break
		}
	}
}
