;; from exercise 3.3 (with additions)
(define (make-passwordless-account balance)
  (define (withdraw amount)
    (if (>= balance amount)
	(begin (set! balance (- balance amount))
	       balance)
	"Insufficient funds"))
  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)
  (define (dispatch m)
    (cond ((eq? m 'withdraw) withdraw)
	  ((eq? m 'deposit) deposit)
	  (else (error "Unknown request -- MAKE-ACCOUNT" m))))
  dispatch)

(define (make-password-account account password)
  (define (dispatch p m)
    (if (eq? p password) 
	(cond ((eq? m 'get-internal-account) account)
	      (else (account m)))
	(error "Incorrect password")))
  dispatch)

(define (make-account balance password)
  (make-password-account (make-passwordless-account balance) password))

(define (make-joint account password new-password)
  (let ((passwordless-account (account password 'get-internal-account)))
    (make-password-account passwordless-account new-password)))

;; exercise 3.8
;; define (f n) such that:
;;  (+ (f 0) (f 1)) => 0 if + evaluates left-to-right and 
;;  (+ (f 0) (f 1)) => 1 if + evaluates right-to-left
(define f
  (let ((state 1))
    (lambda (n)
      (set! state (* state n))
      state)))
