;; here there be math
;; see exercise 3.5 for explanation

(define (monte-carlo trials experiment)
  (define (iter trials-remaining trials-passed)
    (cond ((= trials-remaining 0)
	   (/ trials-passed trials))
	  ((experiment)
	   (iter (- trials-remaining 1) (+ trials-passed 1)))
	  (else
	   (iter (- trials-remaining 1) trials-passed))))
  (iter trials 0))

(define (estimate-pi trials)
  (* (estimate-integral (lambda (x y)
			  (<= (+ (* x x) (* y y)) 1))
			-1.0 1.0 -1.0 1.0
			trials) 
     4.0))

(define (random-in-range low high)
  (let ((range (- high low)))
    (+ low (random range))))

(define (estimate-integral p x1 x2 y1 y2 trials)
  (monte-carlo trials 
	       (lambda () (p (random-in-range x1 x2) 
			     (random-in-range y1 y2)))))

;; exercise 3.6

(let ((random-state 17.0))
  (define (rand arg)
    (define (new-random x)
      (let ((a 13.0) (b 23.0) (m 31.0))
	(modulo (+ (* a x) b) m)))
    
    (cond ((eq? arg 'generate)
	   (begin (set! random-state (new-random random-state))
		  random-state))
	  ((eq? arg 'reset) (lambda (n) (set! random-state n)))
	  (else (error "unknown argument")))))

