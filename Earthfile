VERSION 0.8

FROM golang:1.24-rc-alpine3.21

WORKDIR /go-server

deps:
  COPY go.mod go.sum ./
  RUN go mod download

src:
  FROM +deps
  COPY *.go ./

build:
  FROM +src
  COPY main.go quotes.go .
  RUN go build -o build/quotes .
  SAVE ARTIFACT build/quotes AS LOCAL ./dist/quotes