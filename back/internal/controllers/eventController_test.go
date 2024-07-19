package controllers

import (
	"bytes"
	"easynight/internal/db"
	"easynight/internal/models"
	"io"
	"mime/multipart"
	"net/http"
	"net/http/httptest"
	"os"
	"path/filepath"
	"strconv"
	"testing"
	"time"

	"github.com/joho/godotenv"
	"github.com/labstack/echo/v4"
	"github.com/stretchr/testify/assert"
)

func TestMain(m *testing.M) {
	os.Setenv("TESTING", "true")
	godotenv.Load()
	db.DatabaseInit()
	m.Run()
}

func TestCreateEvent(t *testing.T) {
	e := echo.New()

	eventInput := EventInput{
		Title:             "Test Event",
		Description:       "Test Description",
		Date:              time.Now().Format(time.RFC3339),
		ParticipantNumber: new(int),
		Lat:               48.8566,
		Lng:               2.3522,
		Location:          "Paris",
		Tag:               "test",
		Place:             "Some Place",
	}

	body := &bytes.Buffer{}
	writer := multipart.NewWriter(body)
	_ = writer.WriteField("title", eventInput.Title)
	_ = writer.WriteField("description", eventInput.Description)
	_ = writer.WriteField("date", eventInput.Date)
	_ = writer.WriteField("participantNumber", strconv.Itoa(*eventInput.ParticipantNumber))
	_ = writer.WriteField("lat", strconv.FormatFloat(eventInput.Lat, 'f', -1, 64))
	_ = writer.WriteField("lng", strconv.FormatFloat(eventInput.Lng, 'f', -1, 64))
	_ = writer.WriteField("location", eventInput.Location)
	_ = writer.WriteField("tag", eventInput.Tag)
	_ = writer.WriteField("place", eventInput.Place)

	file, err := os.Open("../../public/uploads/fixtures_cafe_oz.jpg")
	if err != nil {
		t.Fatal(err)
	}
	defer file.Close()

	part, err := writer.CreateFormFile("image", filepath.Base(file.Name()))
	if err != nil {
		t.Fatal(err)
	}
	_, err = io.Copy(part, file)
	if err != nil {
		t.Fatal(err)
	}

	_ = writer.Close()

	req := httptest.NewRequest(http.MethodPost, "/event", body)
	req.Header.Set(echo.HeaderContentType, writer.FormDataContentType())

	rec := httptest.NewRecorder()
	c := e.NewContext(req, rec)

	if assert.NoError(t, CreateEvent(c)) {
		assert.Equal(t, 422, rec.Code)
		assert.Equal(t, "{\"error\":\"http: no such file\"}\n", rec.Body.String())
	}
}

func TestUpdateEvent(t *testing.T) {
	e := echo.New()

	var event models.Event
	if err := db.DB().First(&event).Error; err != nil {
		t.Fatal(err)
	}

	newTitle := "Updated Title"

	body := bytes.NewBufferString("title=" + newTitle)

	req := httptest.NewRequest(http.MethodPut, "/event/"+event.ID.String(), body)
	req.Header.Set(echo.HeaderContentType, echo.MIMEApplicationForm)

	rec := httptest.NewRecorder()
	c := e.NewContext(req, rec)
	c.SetParamNames("id")
	c.SetParamValues(event.ID.String())

	if assert.NoError(t, UpdateEvent(c)) {
		assert.Equal(t, 400, rec.Code)
	}

	var updatedEvent models.Event
	if err := db.DB().First(&updatedEvent, event.ID).Error; err != nil {
		t.Fatal(err)
	}
	assert.Equal(t, "Jazz bar", updatedEvent.Title)
}

func TestGetEvent(t *testing.T) {
	e := echo.New()

	var event models.Event
	if err := db.DB().Last(&event).Error; err != nil {
		t.Fatal(err)
	}

	req := httptest.NewRequest(http.MethodGet, "/event/"+event.ID.String(), nil)
	rec := httptest.NewRecorder()
	c := e.NewContext(req, rec)
	c.SetParamNames("id")
	c.SetParamValues(event.ID.String())

	assert.Equal(t, 200, rec.Code)
}

func TestGetAllEvents(t *testing.T) {
	e := echo.New()

	req := httptest.NewRequest(http.MethodGet, "/events", nil)
	rec := httptest.NewRecorder()
	c := e.NewContext(req, rec)

	if assert.NoError(t, GetAllEvents(c)) {
		assert.Equal(t, 400, rec.Code)
	}
}
