package main

import (
	"database/sql"
	"embed"
	"html/template"
	"log"
	"net/http"
	"os"
	"strings"

	_ "modernc.org/sqlite"
)

//go:embed templates/*
var resources embed.FS

var t = template.Must(template.ParseFS(resources, "templates/*"))

type UserData struct {
	ID int32
	Name, Email string
}

func GetUsers(db *sql.DB) ([]*UserData, error) {
	stmt := `SELECT id, name, email FROM users ORDER BY email ASC`
	rows, err := db.Query(stmt)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	urls := []*UserData{}
	for rows.Next() {
		url := &UserData{}
		err := rows.Scan(&url.ID, &url.Name, &url.Email)
		if err != nil {
			return nil, err
		}
		urls = append(urls, url)
	}

	if err = rows.Err(); err != nil {
		return nil, err
	}
	return urls, nil
}

type PageData struct {
	Region, Version string
	Users []*UserData
}

func main() {
	port := os.Getenv("PORT")
	if port == "" {
		port = "8001"
	}

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		data := PageData{
			Region:  os.Getenv("FLY_REGION"),
			Version: os.Getenv("APP_VERSION"),
		}

		db, err := sql.Open("sqlite", strings.TrimPrefix(os.Getenv("DATABASE_URL"), "sqlite:"))
		if err != nil {
			log.Fatal(err)
		}
		if err = db.Ping(); err != nil {
			log.Fatal(err)
		}
		defer db.Close()
		users, err := GetUsers(db)
		if err != nil {
			log.Fatal(err)
		}
		data.Users = users

		t.ExecuteTemplate(w, "index.html.tmpl", data)
	})

	log.Println("listening on", port)
	log.Fatal(http.ListenAndServe(":"+port, nil))
}
