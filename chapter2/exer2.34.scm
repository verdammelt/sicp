(load "sequences.scm")

;;;
;;; a(n)x^(n) + a(n-1)x^(n-1) + ... + a(1)x + a(0)
;;; horner's rule translates this to:
;;; (...(a(n)x + a(n-1))x + ... + a(1))x + a(0)
;;; 
;; horner-eval
;; (define (horner-eval x coefficient-sequence)
;;   (accumulate (lambda (this-coeff higher-terms) <??>)
;; 	      0
;; 	      coefficient-sequence))
(define (horner-eval x coefficient-sequence)
  (accumulate 
   (lambda (this-coeff higher-terms) 
     (+ (* higher-terms x) this-coeff))
   0
   coefficient-sequence))

;; use it to compute 1 + 3x + 5x^3 + x^5 where x = 2
(newline)
(display "compute 1 + 3x + 5x^3 + x^5 where x = 2 ==> ")
(display (horner-eval 2 (list 1 3 0 5 0 1)))
