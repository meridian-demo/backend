package main
 
import (
	"encoding/json"
	"fmt"
	"net/http"
	"os"
	"strings"

	"github.com/sirupsen/logrus" 
)    

// feature flag to always return JSON
var alwaysJSON = strings.EqualFold(os.Getenv("FF_ALWAYS_JSON"), "true")
 
func main() {
	quotes, err := Quotes()  
	if err != nil {
		logrus.Fatal(err)
	}

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		// common headers
		w.Header().Set("Access-Control-Allow-Origin", "*")
		w.Header().Set("Access-Control-Max-Age", "15")

		quote := RandomQuote(quotes)
		logrus.Info(quote)

		if alwaysJSON {
			// JSON response
			w.Header().Set("Content-Type", "application/json; charset=utf-8")

			// simple JSON shape: { "quote": "<text>" }
			_ = json.NewEncoder(w).Encode(map[string]string{
				"quote": quote,
			})
			return
		}

		// plain text response
		w.Header().Set("Content-Type", "text/plain; charset=utf-8")
		fmt.Fprint(w, quote)
	})

	http.ListenAndServe(":80", nil)
}
