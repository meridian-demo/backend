FROM cgr.dev/chainguard/go:latest-dev

LABEL application_name="backend"
LABEL description="Backend service for Meridian quotes application"
LABEL owner="meridian-demo"
LABEL source_uri="https://github.com/meridian-demo/backend"

WORKDIR /go-server
COPY go.mod go.sum ./
RUN go mod download
COPY *.go ./
COPY main.go quotes.go .
RUN go build -o build/quotes .
