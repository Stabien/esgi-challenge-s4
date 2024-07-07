package utils

import (
	"encoding/base64"
	"io"
	"mime/multipart"
	"os"
	"time"
)

func UploadFile(file *multipart.FileHeader) (string, error) {
	src, err := file.Open()

	if err != nil {
		return "", err
	}

	defer src.Close()

	// Destination
	dst, err := os.Create("public/uploads/" + file.Filename + time.Now().Local().String())
	if err != nil {
		return "", err
	}
	defer dst.Close()

	// Copy
	if _, err = io.Copy(dst, src); err != nil {
		return "", err
	}

	return dst.Name(), err
}

func ReadAndEncodeFile(filePath string) (string, error) {
	data, err := os.ReadFile(filePath)
	if err != nil {
		return "", err
	}

	encodedData := base64.StdEncoding.EncodeToString(data)
	return encodedData, nil
}
