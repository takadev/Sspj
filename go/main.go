package main

import (
    "github.com/julienschmidt/httprouter"

    "net/http"
    "log"
)

func main() {
    router := httprouter.New()
    router.GET("/", Index)
    router.GET("/user/:id", ShowUser)

    log.Fatal(http.ListenAndServe(":8999", router))
}
