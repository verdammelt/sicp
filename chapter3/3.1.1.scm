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

;; exercise 3.4
;; add to the previous exercise - call the cops if a wrong password 
;; was used more than 7 times in a row
(define (make-password-checker password)
  (let ((num-failed-attempts 0))
    (define (call-the-cops)
      (error "Please stay where you are - the police have been dispatched to your location."))
    
    (define (failed-password)
      (if (< num-failed-attempts 7)
	  (begin (set! num-failed-attempts (1+ num-failed-attempts))
		 (error "Incorrect password"))
	  (call-the-cops)))
    
    (define (with-password-check attempted-password on-success)
      (if (eq? attempted-password password)
	  (begin 
	    (set! num-failed-attempts 0)
	    (on-success))
	  (failed-password)))
    with-password-check))

(define (make-account balance password)
  (define (withdraw amount)
    (if (>= balance amount)
	(begin (set! balance (- balance amount))
	       balance)
	"Insufficient funds"))

  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)

  (define password-checker (make-password-checker password))

  (define (dispatch attempted-password m)
    (password-checker attempted-password 
		      (lambda ()
			(cond ((eq? m 'withdraw) withdraw)
			      ((eq? m 'deposit) deposit)
			      (else (error "Unknown request -- MAKE-ACCOUNT"
					   m))))))
  
  dispatch)

