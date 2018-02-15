package main

import "time"

type jsonTime struct {
    time.Time
}

type User struct {
    Id           int       `json:"id"`
    Name         string    `json:"name"`
    Email        string    `json:"email"`
    Introduction string    `json:"introduction"`
    Date         jsonTime  `json:"date"`
    Debug        string    `json:"param"`
}
