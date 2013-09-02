(define (average x y)
  (/ (+ x y) 2.0))

(define (sqrt-improve guess x)
  (average guess (/ x guess)))

(define (sqrt-stream x)
  (define guesses (cons-stream 1.0
			       (stream-map (lambda (guess)
					     (sqrt-improve guess x))
					   guesses)))
  guesses)

(define (euler-transform s)
  (let ((s0 (stream-ref s 0))
	(s1 (stream-ref s 1))
	(s2 (stream-ref s 2)))
    (cons-stream (- s2 (/ (square (- s2 s1))
			  (+ s0 (* -2 s1) s2)))
		 (euler-transform (stream-cdr s)))))

(define (make-tableau transform s)
  (cons-stream s (make-tableau transform (transform s))))

(define (accelerated-sequence transform s)
  (stream-map stream-car (make-tableau transform s)))

;; exercise 3.61
;; Louis P. Reasoner wonders why we couldn't define sqrt-stream like this:
(define (sqrt-stream-2 x)
  (cons-stream 1.0
	       (stream-map (lambda (guess)
			     (sqrt-improve guess x))
			   (sqrt-stream-2 x))))
;; Alyssa says it would be inefficient - why?

;; mjs: Well in Louis' version, even with there is a separate list
;; of guesses for each promise to compute made. In the original there
;; was only one such stream created (which was defined in terms of 
;; itself)
;; Thus even with memoization much more computation needs to be done
;; because each promise from each stream needs to be forced.

;; exer 3.64
;; write stream-limit which cdrs down a stream until it finds two 
;; elements which are different by less than a tolerance - returns
;; the second of those elements
(define (stream-cadr stream)
  (stream-car (stream-cdr stream)))
(define (stream-limit stream tolerance)
  (if (< 
       (abs (- (stream-car stream) (stream-cadr stream)))
       tolerance)
      (stream-cadr stream)
      (stream-limit (stream-cdr stream) tolerance)))

;; exer 3.65
;; approximate ln(2) as pi was approximated in the book
;; the series is 1 - 1/2 + 1/3 - 1/4...
(define (ln-2-summands n)
  (cons-stream (/ 1.0 n)
	       (stream-map - (ln-2-summands (1+ n)))))
(define (partial-sums stream)
  (cons-stream (stream-car stream)
	       (add-streams (stream-cdr stream)
			    (partial-sums stream))))
(define ln-2-stream
  (partial-sums (ln-2-summands 1)))

;; tried (stream-limit ln-2-stream 0.0001) and it effectively hung
;; used (stream-head <stream> 10) to get an idea of the first 10 item
;; of each on of the streams. ln-2-stream barely converged - 
;; euler-transform of it did well but the accelerated-sequence of it
;; was pretty amazing.


;; Infinite streams of pairs
(define (interleave s1 s2)
  (if (stream-null? s1)
      s2
      (cons-stream (stream-car s1)
		   (interleave s2 (stream-cdr s1)))))

(define (pairs s t)
  (cons-stream
   (list (stream-car s) (stream-car t))
   (interleave
    (stream-map (lambda (x) (list (stream-car s) x))
		(stream-cdr t))
    (pairs (stream-cdr s) (stream-cdr t)))))

;; exercise 3.66-3.68 - skipped

;; exercise 3.69
;; write a triples function (like pairs) then use it to find 
;; pythagorean triples
(define (add-streams s1 s2) (stream-map + s1 s2))
(define ones (cons-stream 1 ones))
(define integers (cons-stream 1 (add-streams ones integers)))
(define (triples s1 s2 s3)
  (cons-stream 
    (list
      (stream-car s1)
      (stream-car s2)
      (stream-car s3))
    (interleave
      (stream-map
        (lambda (x) (append (list (stream-car s1)) x))
        (stream-cdr (pairs s2 s3)))
      (triples 
        (stream-cdr s1)
        (stream-cdr s2)
        (stream-cdr s3)))))

(define pythagorean-triples
  (stream-filter (lambda (x)
		   (let ((i (car x))
			 (j (cadr x))
			 (k (caddr x)))
		     (if (and (= i 3)
			      (= j 4)
			      (= k 5))
			 (display 'FOUND-ONE))
		     (= (+ (square i)
			   (square j))
			(square k))))
		 (triples integers integers integers)))

