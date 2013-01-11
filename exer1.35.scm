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

;; show that phi (the golden ration from section 1.2.2) is a fixed
;; point of the transformation x->1+1/x
;; The Golden Ratio is: 1.61803398875
;;
(define (phi)
  (fixed-point (lambda (x) (+ 1 (/ 1 x)))
	       1.0))

(newline)
(format #t "(phi) => ~A~%" (phi))
