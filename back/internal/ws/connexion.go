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

type Message struct {
	Sender string    `json:"sender"`
	Date   time.Time `json:"date"`
	Text   string    `json:"text"`
	UserId string    `json:"userId"`
}

func HandleRoomWebSocket(c echo.Context) error {
	roomName := c.QueryParam("roomName")

	room, ok := activeRooms[roomName]
	if !ok {
		room = &Room{
			Name:        roomName,
			Connections: make(map[string]*websocket.Conn),
		}
		activeRooms[roomName] = room
	}

	ws, err := upgrader.Upgrade(c.Response(), c.Request(), nil)
	if err != nil {
		log.Println("Upgrade error:", err)
		return err
	}
	defer ws.Close()

	connectionID := "connection-" + uuid.New().String()
	room.Connections[connectionID] = ws
	defer delete(room.Connections, connectionID)

	sendConnectedClients(room)

	for {

		var clientMessage Message
		messageType, p, err := ws.ReadMessage()
		if err != nil {
			log.Println("Read error:", err)
			break
		}

		if err := json.Unmarshal(p, &clientMessage); err != nil {
			log.Println("JSON unmarshal error:", err)
			continue
		}

		if clientMessage.Sender == "" {
			clientMessage.Sender = connectionID
		}

		// clientMessage.Date = time.Now().UTC()

		messageJSON, err := json.Marshal(clientMessage)
		if err != nil {
			log.Println("JSON marshal error:", err)
			continue
		}
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
	var connectedClients []string
	for id := range room.Connections {
		connectedClients = append(connectedClients, id)
	}

	clientsJSON, err := json.Marshal(connectedClients)
	if err != nil {
		log.Println("JSON marshal error:", err)
		return
	}

	for _, conn := range room.Connections {
		if err := conn.WriteMessage(websocket.TextMessage, clientsJSON); err != nil {
			log.Println("Write error:", err)
			break
		}
	}
}
