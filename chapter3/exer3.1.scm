;; exercise 3.1
(define (make-accumulator value)
  (lambda (n) 
    (set! value (+ n value))
    value))

;; exercise 3.2
(define (make-monitored fn)
  (let ((num-calls 0))
    (lambda (arg)
      (cond ((eq? arg 'how-many-calls?) num-calls)
	    ((eq? arg 'reset-count) (begin (set! num-calls 0) num-calls))
	    (else (begin (set! num-calls (1+ num-calls)) (fn arg)))))))

;; exercise 3.3
;; add a password to the make-account code shown in the book
(define (make-account balance password)
  (define (withdraw amount)
    (if (>= balance amount)
	(begin (set! balance (- balance amount))
	       balance)
	"Insufficient funds"))
  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)
  (define (dispatch attempted-password m)
    (if (eq? attempted-password password)
	(cond ((eq? m 'withdraw) withdraw)
	      ((eq? m 'deposit) deposit)
	      (else (error "Unknown request -- MAKE-ACCOUNT"
			   m)))
	(error "Incorrect password")))
  dispatch)



