package main

import (
    "fmt"
    "log"
    "net/http"
    "os"
)

func handler(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintf(w, "Hi there, I love %s!\n", r.URL.Path[1:])
}

func main() {
    http.HandleFunc("/", handler)
    addr := ":8080"
    if port, ok := os.LookupEnv("PORT"); ok {
	addr = ":" + port
    }
    log.Fatal(http.ListenAndServe(addr, nil))
}
