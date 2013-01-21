;;; create procedure iterative-improve
;;; it takes two procedures - one to determine if a guess is good enough
;;; the other computes the next guess.
;;; it returns a procedure which takes a guess and iterates upon it
;;; until it is good enough.
;;;
;;; use it to rewrite the sqrt procedure (from 1.1.7)
;; (define (sqrt x)
;;   (define (sqrt-iter guess)
;;     (if (good-enough? guess x)
;; 	guess
;; 	(sqrt-iter (improve guess x) x)))
;;   (define (good-enough? guess x)
;;     (< (abs (- (square guess) x)) 0.001))
;;   (define (improve x)
;;     (average guess (/ x guess)))
;;   (sqrt-iter 1.0 x))

;;; and fixed-point procedure (1.3.3)
;; (define (fixed-point f first-guess)
;;   (define tolerance 0.00001)
;;   (define (close-enough? v1 v2)
;;     (< (abs (- v1 v2)) tolerance))
;;   (define (try guess)
;;     (let ((next (f guess)))
;;       (if (close-enough? guess next)
;; 	  next
;; 	  (try next))))
;;   (try first-guess))

(define (iterative-improve good-enough? improve)
  (lambda (guess)
  	       (if (good-enough? guess)
  		   guess
  		   ((iterative-improve good-enough? improve) 
  		    (improve guess)))))

(define (sqrt x)
  ((iterative-improve 
    (lambda (guess) (< (abs (- (square guess) x)) 0.001))
    (lambda (guess) (average guess (/ x guess)))) 1.0))

(newline) (display (sqrt 4))
(newline) (display (sqrt 2))

(define (fixed-point f first-guess)
  ((iterative-improve 
    (lambda (guess) (< (abs (- guess (f guess))) 0.00001))
    (lambda (guess) (f guess))) first-guess))

(define (sqrt-fixed-point x)
  (fixed-point (lambda (y) (average y (/ x y)))	1.0))

(newline) (display (sqrt-fixed-point 4))
(newline) (display (sqrt-fixed-point 2))
