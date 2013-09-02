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

;; exercise 3.55
(define (partial-sums stream)
  (define partial-sum-stream 
    (cons-stream (stream-car stream)
		 (add-streams partial-sum-stream (stream-cdr stream))))
  partial-sum-stream)

;; exercise 3.56
;; Hamming enumeration:
;; stream of all positive integers with 2, 3, 5 as only prime factors
(define (merge s1 s2)
  (cond ((stream-null? s1) s2)
	((stream-null? s2) s1)
	(else
	 (let ((s1car (stream-car s1))
	       (s2car (stream-car s2)))
	   (cond ((< s1car s2car)
		  (cons-stream s1car (merge (stream-cdr s1) s2)))
		 ((> s1car s2car)
		  (cons-stream s2car (merge s1 (stream-cdr s2))))
		 (else
		  (cons-stream s1car
			       (merge (stream-cdr s1)
				      (stream-cdr s2)))))))))

(define hamming (cons-stream 1 (merge (scale-stream hamming 2)
				      (merge (scale-stream hamming 3)
					     (scale-stream hamming 5)))))
