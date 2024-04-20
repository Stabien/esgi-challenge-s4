package utils

import (
	"github.com/skip2/go-qrcode"
)

func GenerateQRCode() ([]byte, error) {
	qrCode, err := qrcode.Encode("https://example.org", qrcode.Medium, 256)
	if err != nil {
		return nil, err
	}
	return qrCode, nil
}
