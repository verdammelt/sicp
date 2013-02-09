;; (rest arguments in scheme like this:)
;; (define (foo x y . z)...

;; define same-parity which takes 1 or more arguments and returns all
;; arguments which have the same even/odd parity as the first
(define (same-parity first . rest)
  (define (same-parity-intern nums)
    (cond ((null? nums) (list))
	  ((= (remainder first 2)
	      (remainder (car nums) 2))
	   (append (list (car nums)) (same-parity-intern (cdr nums))))
	  (else
	   (same-parity-intern (cdr nums)))))
  (append (list first) (same-parity-intern rest)))

;; from Bill the Lizard
(define (same-parity2 first . rest)
  (define (iter nums answer)
    (if (null? nums) answer
	(iter (cdr nums)
	      (if (= (remainder first 2)
		     (remainder (car nums) 2))
		  (append answer (list (car nums)))
		  answer))))
  (iter rest (list first)))

(newline)
(display (same-parity 1 2 3 4 5 6))
(newline)
(display (same-parity 2 1 3 4 5 6))




