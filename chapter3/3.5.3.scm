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

;; exercise 3.70
;; extend pairs to instead of interleaving - use some sort or merge 
;; operation
(define (weighted-merge weight-fn s1 s2)
  (let ((merge (lambda (s1 s2)
		 (weighted-merge weight-fn s1 s2))))
    (cond ((stream-null? s1) s2)
	  ((stream-null? s2) s1)
	  (else
	   (let ((diff (- (weight-fn (stream-car s1))
			  (weight-fn (stream-car s2)))))
	     (if (<= diff 0)
		 (cons-stream (stream-car s1) (merge (stream-cdr s1) s2))
		 (cons-stream (stream-car s2) (merge s1 (stream-cdr s2)))))))))

(define (weighted-pairs s t weight-fn)
  (cons-stream
   (list (stream-car s) (stream-car t))
   (weighted-merge weight-fn
		   (stream-map (lambda (x) (list (stream-car s) x))
			       (stream-cdr t))
		   (weighted-pairs (stream-cdr s) (stream-cdr t) weight-fn))))

;; part a. all pairs (i, j) compared by i+j
(define pairs-sorted
  (weighted-pairs integers integers (lambda (x) (+ (car x) (cadr x)))))

;; part b. all pairs (i, j) with i<=j where neither i nor j are 
;; divisible by 2, 3, 5 and pairs are ordered according to 2i+3j+5ij
(define (divisible? x y)
  (= (remainder x y) 0))
(define (divisible-by-any? x ys)
  (cond ((null? ys) false)
	((divisible? x (car ys)) true)
	(else (divisible-by-any? x (cdr ys)))))

(define weird-thing
  (stream-filter (lambda (x)
		   (let ((i (car x))
			 (j (cadr x))
			 (verboten (list 2 3 5)))
		     (and (not (divisible-by-any? i verboten))
			  (not (divisible-by-any? j verboten)))))
		 (weighted-pairs integers integers
				 (lambda (x)
				   (let ((i (car x))
					 (j (cadr x)))
				     (+ (* 2 i) (* 3 j) (* 5 i j)))))))


;; exercise 3.71 
(define (cube-sum p)
  (let ((i (car p))
	(j (cadr p)))
    (+ (* i i i) (* j j j))))

(define ram-nums
  (let ((pairs (weighted-pairs integers integers cube-sum)))
    (stream-map 
     (lambda (x) (list (cube-sum (car x)) x))
     (stream-filter 
      (lambda (poss) 
	(let ((x (car poss))
	      (y (cadr poss)))
	  (= (cube-sum x) (cube-sum y))))
      (stream-map 
       (lambda (x y) (list x y)) 
       pairs (stream-cdr pairs))))))

;; exercise 3.72
;; numbers which can be made by sum of two squares in 3 ways
(define (square-sum p) (+ (square (car p)) (square (cadr p))))
(define sum-of-squares-three-way
  (let ((pairs (weighted-pairs integers integers square-sum)))
    (stream-map
     (lambda (x) (list (square-sum (car x)) x))
     (stream-filter
      (lambda (poss)
	(let ((x (car poss))
	      (y (cadr poss))
	      (z (caddr poss)))
	  (= (square-sum x) (square-sum y) (square-sum z))))
      (stream-map
       (lambda (x y z) (list x y z))
       pairs (stream-cdr pairs) (stream-cdr (stream-cdr pairs)))))))

;; streams as signals
(define (scale-stream s f) (stream-map (lambda (x) (* x f)) s))
(define (integral integrand initial-value dt)
  (define int
    (cons-stream initial-value
		 (add-streams (scale-stream integrand dt)
			      int)))
  int)

;; exercise 3.73
(define (RC r c dt)
  (lambda (i v0)
    (add-streams
     (scale-stream i r)
     (scale-stream (integral i v0 dt) (/ 1 c)))))

;; exercise 3.74
;; mjs: since i did this style above i thought this one was prety easy.
;; (define zero-crossings
;;   (stream-map sign-change-detector sense-data (stream cdr sense-data)))
;; mjs: commented out so file could load.

;; exercise 3.75 & 3.76 skipped due to apathy.

