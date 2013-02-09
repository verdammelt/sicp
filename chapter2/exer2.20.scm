;; (rest arguments in scheme like this:)
;; (define (foo x y . z)...

;; define same-parity which takes 1 or more arguments and returns all
;; arguments which have the same even/odd parity as the first
(define (same-parity first . rest)
  (define (same-parity-intern nums)
    (cond ((null? nums) (list))
	  ((and (even? first) (even? (car nums))) 
	   (append (list (car nums)) (same-parity-intern (cdr nums))))
	  ((and (odd? first) (odd? (car nums)))
	   (append (list (car nums)) (same-parity-intern (cdr nums))))
	  (else
	   (same-parity-intern (cdr nums)))))
  (append (list first) (same-parity-intern rest)))


