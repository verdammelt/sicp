;; signal primitives
(define (valid-signal? s)
  (or (= s 1) (= s 0)))

(define (logical-not s)
  (cond ((not (valid-signal? s))
	 (error "Invalid signal" s))
	((= s 0) 1))
	((= s 1) 0))

(define (logical-and s1 s2)
  (cond ((not (valid-signal? s1))
	 (error "Invalid signal s1" s1))
	((not (valid-signal? s2))
	 (error "Invalid signal s2" s2))
	((and (= s1 1) (= s2 1)) 1)
	(else 0)))
(define (logical-or s1 s2)
  (cond ((not (valid-signal? s1))
	 (error "Invalid signal s1" s1))
	((not (valid-signal? s2))
	 (error "Invalid signal s2" s2))
	((or (= s1 1) (= s2 1)) 1)
	(else 0)))

;; the wire primitives
(define (get-signal w))
(define (set-signal! w new))
(define (add-action! w proc))

;; the agenda primitives
(define (after-delay delay proc))

;; the circuits
(define inverter-delay 0)
(define (inverter input output)
  (define (invert-input)
    (let ((new-value (logical-not (get-signal input))))
      (after-delay inverter-delay
		   (lambda () (set-signal! output new-value)))))
  (add-action! input invert-input)
  'ok)

(define and-gate-delay 0)
(define (and-gate a1 a2 output)
  (define (and-gate-procedure)
    (let ((new-value
	   (logical-and (get-signal s1)
			(get-signal s2))))
      (after-delay and-gate-delay
		   (lambda ()
		     (set-signal! output new-value)))))
  (add-action! a1 and-gate-procedure)
  (add-action! a2 and-gate-procedure)
  'ok)

;; exercise 3.28 - define an or-gate
(define or-gate-delay 0)
(define (or-gate a1 a2 output)
  (define (or-gate-procedure)
    (let ((new-value
	   (logical-or (get-signal s1)
		       (get-signal s2))))
      (after-delay or-gate-delay
		   (lambda () (set-signal! output new-value)))))
  (add-action! a1 or-gate-procedure)
  (add-action! a2 or-gate-procedure)
  'ok)

;; exercise 3.29 - define or-gate as with and-gate and inverters
;; or-gate = and-gate with negated inputs and outputs
(define (other-or-gate a1 a2 output)
  (let ((a1-inv (make-wire))
	(a2-inv (make-wire))
	(and-output (make-wire)))
    (inverter a1 a1-inv)
    (inverter a2 a2-inv)
    (and-gate a1-inv a2-inv and-output)
    (inverter and-output output)))

;; the delay of this other-or-gate would be: 
;; (+ and-gate-delay (* 2 inverter-delay)) 
;;    - if a1 & a2 were set at the same time
;; (+ and-gate-delay (* 3 inverter-delay))
;;    - if a1 & a2 are signaled at different times

(define (half-adder a b s c)
  (let ((d (make-wire)) 
	(e (make-wire)))
    (or-gate a b d)
    (and-gate a b c)
    (inverter c e)
    (and-gate d e s)
    'ok))
(define (full-adder (a b c-in sum c-out))
  (let ((s (make-wire))
	(c1 (make-wire))
	(c2 (make-wire)))
    (half-adder b c-in s c1)
    (half-adder a s sum c2)
    (or-gate c1 c2 c-out)
    'ok))

;; exercise 3.30 -- ripple-carry adder
;; A1..An, B1..Bn add together to make S1..Sn with the final  C
;; take 4 arguments: 3 lists of n wires each (A, B, S) and also a C
;; (the initial c-in on the first full-adder is 0)
(define (ripple-carry-adder list-a list-b list-s c)
  (define (ripple-carry-adder-helper list-a list-b list-s c-in c-out)
    (if (null? list-a) 'ok
	(full-adder (car list-a)
		    (car list-b)
		    c-in
		    (car list-s)
		    c-out)
	(ripple-carry-adder-helper (cdr list-a)
				   (cdr list-b)
				   (cdr list-s)
				   c-out
				   (make-wire))))
  (let ((c-init (make-wire)))
    (ripple-carry-adder-helper list-a list-b list-s c-init c)
    (set-signal c-init 0)))
