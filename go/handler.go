package main

import (
    "github.com/julienschmidt/httprouter"

    "encoding/json"
    "fmt"
    "time"
    "net/http"
)

func (j jsonTime) format() string {
    return j.Time.Format("2006-01-02 15:04:05")
}

func (j jsonTime) MarshalJSON() ([]byte, error) {
    return []byte(`"` + j.format() + `"`), nil
}

func Index(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
    fmt.Fprintf(w, "Hello world!")
}

// http://localhost:8080/user/1 が叩かれると呼ばれる
func ShowUser(w http.ResponseWriter, r *http.Request, ps httprouter.Params) {
    param := ps.ByName("id")
    currentTime := time.Now()
    var user User
    if param == "1" {
        user = User {
            Id:           1,
            Name:         "ブタ",
            Email:       "pig@boo.com",
            Introduction: "こんにちは、ブタです。" +
                          "みなさん元気ですか？ 今日も1日お仕事頑張りましょう。",
            Date: jsonTime {currentTime},
            Debug: param,
        }
    } else {
        user = User {
            Id:           2,
            Name:         "犬",
            Email:       "dog@boo.com",
            Introduction: "こんにちは、犬です。" +
                          "みなさん元気ですか？ 今日も1日お仕事頑張りましょう。",
            Date: jsonTime {currentTime},
            Debug: param,
        }
    }

    // 構造体をJSONへ変換
    data, _ := json.Marshal(user)

    defer func() {
        w.Header().Set("Content-Type", "application/json")
        fmt.Fprint(w, string(data))
    }()
}
