package controllers

import (
	"fmt"
	"io"
	"net/http"
)

func HelloHandle(w http.ResponseWriter, r *http.Request) {
	_, _ = io.WriteString(w, fmt.Sprintf("[%s] Hello World!", r.Method))
}
