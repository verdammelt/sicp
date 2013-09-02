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
  (cons-stream (stream-car stream)
	       (add-streams (stream-cdr stream)
			    (partial-sums stream))))

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

;; exercise 3.57
;; skipping - but quickly: without memoization we'd calculate each fib
;; number over and over again as we needed it for each fib(n-1) and
;; fib(n-2) to compute fib(n)

;; exercise 3.58
;; what does this do
(define (expand num den radix)
  (cons-stream
   (quotient (* num radix) den)
   (expand (remainder (* num radix) den) den radix)))
;; specifically for (expand 1 7 10) and (expand 3 8 10)

;; mjs: I think that this will create a stream which when takin
;; together are the digits of num/den
;; so (expand 3 8 10) would be 3, 7, 5, 0, 0 ....

;; mjs: i was right!

;; exercise 3.59a
;; integral of a0+a1x+a2x^2... is
;; c+ a0x + (a1/2)x + (a2/3)x^...
(define (div-stream s1 s2)
  (stream-map / s1 s2))
(define (integrate-series coeff-stream)
  (div-stream coeff-stream integers))

;; exercise 3.59b
;; e^x is its own derivative so we can define:
(define exp-series (cons-stream 1 (integrate-stream exp-series)))
;; do the same for sine & cosine given that:
;; d(sine) = cosine
;; d(cosine) = -sine
(define cosine-series
  (cons-stream 1 (integrate-series (scale-stream sine-series -1))))

(define sine-series
  (cons-stream 0 (integrate-series cosine-series)))

;; exer 3.60
(define (mul-series s1 s2)
  (cons-stream 
   (* (stream-car s1) (stream-car s2))
   (add-streams 
    (scale-stream (stream-cdr s2) (stream-car s1))
    (mul-series (stream-cdr s1) s2))))

(define sine-x-squared-plus-cosine-x-squared
  (add-streams
   (mul-series sine-series sine-series)
   (mul-series cosine-series cosine-series)))


