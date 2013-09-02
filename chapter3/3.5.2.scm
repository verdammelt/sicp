(define (add-streams s1 s2)
  (stream-map + s1 s2))
(define (scale-stream stream factor)
  (stream-map (lambda (x) (* x factor)) stream))

(define ones (cons-stream 1 ones))
(define integers (cons-stream 1 (add-streams ones integers)))

;; exercise 3.53
;; what stream does this code produce?
(define s (cons-stream 1 (add-streams s s )))

;; mjs: this will create a stream 1, 2, 4, 8 etc. since it is the
;; doubling of each previous value

;; exercise 3.54
(define (mul-streams s1 s2) (stream-map * s1 s2))

(define factorials (cons-stream 1 (mul-streams
				   (add-streams ones integers)
				   factorials)))
