(define integers
  (cons-stream 1 (stream-map 1+ integers)))

;; 3.50 - define stream-map to make multiple streams as arguments
;; (like map does)
(define (stream-map-2 proc . argstreams)
  (if (stream-null? (car argstreams))
      the-empty-stream
      (cons-stream
       (apply proc (map stream-car argstreams))
       (apply stream-map
	      (cons proc (map stream-cdr argstreams))))))

(define squares (stream-map-2 * integers integers))
