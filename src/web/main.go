package main

import (
	"net/http"
	"time"

	"web/model/log"
	_ "web/routes"
)

func init() {
	http.Handle("/", http.StripPrefix("/", http.FileServer(http.Dir("./public"))))
}

type FilterHandler struct {
}

func (h *FilterHandler) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	defer func(start time.Time) {
		log.Printf("%s %s\n", log.ColorForMethod(r.Method), r.URL.String())
	}(time.Now())

	http.DefaultServeMux.ServeHTTP(w, r)
}

func main() {
	// 过虑器
	filter := &FilterHandler{}
	addr := ":8080"
	log.Println("Listen: " + addr)
	log.Fatal(http.ListenAndServe(addr, filter))
}