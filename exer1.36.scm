(load-option 'format)

(define tolerance 0.00001)

(define (fixed-point f first-guess)
  (define (close-enough? v1 v2)
    (< (abs (- v1 v2)) tolerance))
  (define (try guess)
    (newline) (display guess)
    (let ((next (f guess)))
      (if (close-enough? guess next)
	  next
	  (try next))))
  (try first-guess))

;;; compute x^x=1000 by finding a fixed point of x->log(1000)/log(x)
;;; NOTE scheme log function is natural log (ln) not log10 log10(x) =
;;; (/ (ln x) (ln 10)) (it is unclear from the text of the exercise if
;;; the transformation uses natural log or log10)
(define (x-to-the-x-equals-1000)
  (fixed-point (lambda (x) (/ (log 1000) (log x))) 1.1))

(x-to-the-x-equals-1000) ; this took 37 iterations to get to 4.555538934848503

;; now compare the number of iterations that took with searching for
;; the fixed point with average dampening.

;; what is the average damped version fo (/ (log 1000) (log x))?
;; maybe: (lambda (x) (/ (+ x (/ (log 1000) (log x))) 2))

(define (x-to-the-x-equals-1000-damp)
  (fixed-point 
   (lambda (x) (/ (+ x (/ (log 1000) (log x))) 2))
   1.1))

(newline)
(display 'with-dampening)
(x-to-the-x-equals-1000-damp) ; 13 iterations to reach: 4.555536364911781

