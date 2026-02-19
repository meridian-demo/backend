package middleware

import (
	"log/slog"
	"net/http"
	"time"

	"github.com/google/uuid"
)

// RequestTracing adds a unique request ID and logs request duration.
func RequestTracing(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		requestID := uuid.New().String()
		start := time.Now()

		w.Header().Set("X-Request-ID", requestID)
		r.Header.Set("X-Request-ID", requestID)

		logger := slog.With("request_id", requestID, "method", r.Method, "path", r.URL.Path)
		logger.Info("request started")

		next.ServeHTTP(w, r)

		logger.Info("request completed", "duration_ms", time.Since(start).Milliseconds())
	})
}