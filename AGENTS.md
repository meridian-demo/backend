# Backend API — Agent Instructions

## Project Overview

The backend service is a Go-based REST API that powers the Meridian platform. It handles authentication, data persistence, and business logic for the dashboard and mobile clients.

**Tech stack:** Go 1.22, PostgreSQL, Redis, Docker
**Primary framework:** net/http with chi router

## Architecture

- `cmd/` — Application entrypoints
- `internal/api/` — HTTP handlers and middleware
- `internal/domain/` — Business logic and domain models
- `internal/store/` — Database access layer (PostgreSQL)
- `internal/cache/` — Redis caching layer
- `deploy/` — Terraform, Dockerfiles, and k8s manifests

## Build Commands

```bash
# Build the binary
go build -o bin/backend ./cmd/backend

# Run tests
go test ./...

# Run linter
golangci-lint run

# Build Docker image
docker build -t backend:latest .

# Run locally
docker compose up
```

## Testing

- Unit tests: `go test ./internal/...`
- Integration tests: `go test -tags=integration ./...`
- Coverage report: `go test -coverprofile=coverage.out ./... && go tool cover -html=coverage.out`

## Common Patterns

- Error handling: Use `fmt.Errorf("context: %w", err)` for wrapping
- Logging: Use `slog` structured logger (not logrus)
- Config: Environment variables loaded via `internal/config`
- Database migrations: `migrate` CLI tool, files in `migrations/`

## Code Style

- Follow standard Go conventions (`gofmt`, `goimports`)
- Max function length: ~50 lines preferred
- Table-driven tests for handlers
- Context propagation through all layers