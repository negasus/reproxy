package demo

import (
	"net/http"
	"sync/atomic"
)

func InitPlugin() func(http.Handler) http.Handler {
	return Handler
}

var counter int64

func Handler(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {

		c := atomic.AddInt64(&counter, 1)
		if c%2 == 0 {
			w.Write([]byte("cached data"))
			return
		}

		next.ServeHTTP(w, r)
	})
}
