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



