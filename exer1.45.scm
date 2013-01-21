;;; using the fixed-point mechanism to compute roots
;;; to compute square root you need to use an average dampening
;;; to compute cube roots you need to damp 
;;; to compute 4th roots you need to damp twice
;;; experiment to find out how many times you need to damp for the nth root
;;;
;;; to compute roots by fixed-point use y->x/y^(n-1)
;;;
(define (average x y)
  (/ (+ x y) 2))
(define (fixed-point f first-guess)
  (define tolerance 0.00001)
  (define (close-enough? v1 v2)
    (< (abs (- v1 v2)) tolerance))
  (define (try guess)
    (newline) (display guess)
    (let ((next (f guess)))
      (if (close-enough? guess next)
	  next
	  (try next))))
  (try first-guess))

(define (average-damp f)
  (lambda (x) (average x (f x))))

(define (compose f g)
  (lambda (x) (f (g x))))

(define (repeated f n)
  (if (= n 0)
      (lambda (x) x)
      (compose f 
	       (repeated f (- n 1)))))


;;; after experimenting create a simple procedure to compute nth roots
;;; using fixed-point, average-damp and repeated

;;; experimentation seems to show that dampening has to be repeated m
;;; times for the nth root where 2^m = n 
;;;
;;; e.g for n = 8:
;; ((lambda (x) 
;;    (fixed-point 
;;     ((repeated average-damp 3) (lambda (y) (/ x (expt y 7)))) 
;;     1.0)) 
;;  (expt 2 8))

(define (nth-root n x)
  (define (number-of-dampenings n)
    (truncate (/ (log n) (log 2))))
  (define (repeated-dampening n)
    (repeated average-damp (number-of-dampenings n)))
  (define (f x) (lambda (y) (/ x (expt y (- n 1)))))
  (define (nth-root-proc n)
    (lambda (x) (fixed-point ((repeated-dampening n) (f x)) 1.0)))

  ((nth-root-proc n) x))
  

