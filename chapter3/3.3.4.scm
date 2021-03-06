;; queue primitives
(define (make-queue)
  (let ((front-ptr '())
	(rear-ptr '()))
    (define (dispatch m)
      (cond ((eq? m 'empty?) (null? front-ptr))
	    ((eq? m 'front) (if (dispatch 'empty?) 
				(error "FRONT called on empty queue")
				(car front-ptr)))
	    ((eq? m 'insert!) (lambda (x) 
				(cond ((dispatch 'empty?)
				       (let ((new-pair (cons x '())))
					 (set! front-ptr new-pair)
					 (set! rear-ptr new-pair)))
				      (else (set-cdr! rear-ptr x)
					    (set! rear-ptr x)))))
	    ((eq? m 'delete!) (cond ((dispatch 'empty?)
				     (error "DELETE on empty queue"))
				    (else (set! front-ptr (cdr front-ptr)))))
	    ((eq? m 'print) (cons front-ptr rear-ptr))
	    (else (error "Unknown command"))))
    dispatch))
(define (empty-queue? q) (q 'empty?))
(define (front-queue q) (q 'front))
(define (insert-queue! q n) ((q 'insert!) n))
(define (delete-queue! q) (q 'delete!))

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
(define (make-wire)
  (define (call-each procedures)
    (if (null? procedures)
	'done
	(begin ((car procedures)
		(call-each (cdr procedures))))))

  (let ((signal-value 0) (action-procedures '()))
    (define (set-my-signal! new-value)
      (if (not (= signal-value new-value))
	  (begin (set! signal-value new-value)
		 (call-each action-procedures))
	  'done))
    (define (accept-action-procedure! proc)
      (set! action-procedures (cons proc action-procedures))
      (proc))
    (define (dispatch m)
      (cond ((eq? m 'get-signal) signal-value)
	    ((eq? m 'set-signal!) set-my-signal)
	    ((eq? m 'add-action!) accept-action-procedure!)
	    (else (error "Unknown operation -- WIRE" m))))
    dispatch))

(define (get-signal w)
  (w 'get-signal))
(define (set-signal! w new)
  ((w 'set-signal!) new))
(define (add-action! w proc)
  ((w 'add-action!) proc))

;; the agenda primitives
(define (make-time-segment time queue) (cons time queue))
(define (segment-time s) (car s))
(define (segment-queue s) (cdr s))

(define (make-agenda) (list 0))
(define (current-time a) (car a))
(define (set-current-time! a t) (set-car! a t))
(define (segments a) (cdr a))
(define (set-segments! a s) (set-cdr! a s))
(define (first-segment a) (car (segments a)))
(define (rest-segmetns a) (cdr (segments a)))

(define (empty-agenda? a) (null? (segments a)))

(define (add-to-agenda! time action agenda)
  (define (belongs-before? segments)
    (or (null? segments)
	(< time (segment-time (car segments)))))
  (define (make-new-time-segment time action)
    (let ((q (make-queue)))
      (insert-queue! q action)
      (make-time-segment time q)))
  (define (add-to-segments! segments)
    (if (= (segment-time (car segments)) time)
	(insert-queue! (segment-queue (car segments))
		       action)
	(let ((rest (cdr segments)))
	  (if (belongs-before? rest)
	      (set-cdr!
	       segments
	       (cons (make-new-time-segment time action)
		     (cdr segments)))
	      (add-to-segments! rest)))))
  (let ((segments (segments agenda)))
    (if (belongs-before? segments)
	(set-segments!
	 agenda
	 (cons (make-new-time-segment time action)
	       segments))
	(add-to-segments! segments))))

(define (remove-first-agenda-item! agenda)
  (let ((q (segment-queue (first-segment agenda))))
    (delete-queue! q)
    (if (empty-queue? q)
	(set-segments! agenda (rest-segments agenda)))))

(define (first-agenda-item agenda)
  (if (empty-agenda? agenda)
      (error "Agenda is empty -- FIRST-AGENDA-ITEM")
      (let ((first-seg (first-segment agenda)))
	(set-current-time! agenda (segment-time first-seg))
	(front-queue (segment-queue first-seg)))))


(define *the-agenda* (make-agenda))
(define (after-delay delay proc)
  (add-to-agenda! (+ delay (current-time *the-agenda*))
		  proc
		  *the-agenda*))

(define (propagate)
  (if (empty-agenda? *the-agenda*)
      'done
      (let ((first-item (first-agenda-item *the-agenda*)))
	(first-item)
	(remove-first-agenda-item! *the-agenda*)
	(propagate))))

(define (probe name wire)
  (add-action! wire
	       (lambda ()
		 (newline)
		 (display name)
		 (display " ")
		 (display (current-time *the-agenda*))
		 (display " New-value = ")
		 (display (get-signal wire)))))

;; the circuits
(define *inverter-delay* 2)
(define (inverter input output)
  (define (invert-input)
    (let ((new-value (logical-not (get-signal input))))
      (after-delay *inverter-delay*
		   (lambda () (set-signal! output new-value)))))
  (add-action! input invert-input)
  'ok)

(define *and-gate-delay* 3)
(define (and-gate a1 a2 output)
  (define (and-gate-procedure)
    (let ((new-value
	   (logical-and (get-signal s1)
			(get-signal s2))))
      (after-delay *and-gate-delay*
		   (lambda ()
		     (set-signal! output new-value)))))
  (add-action! a1 and-gate-procedure)
  (add-action! a2 and-gate-procedure)
  'ok)

;; exercise 3.28 - define an or-gate
(define *or-gate-delay* 5)
(define (or-gate a1 a2 output)
  (define (or-gate-procedure)
    (let ((new-value
	   (logical-or (get-signal s1)
		       (get-signal s2))))
      (after-delay *or-gate-delay*
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
(define (dotimes n f)
  (if (> n 0) 
      (begin (f)
	     (dotimes (- n 1) f))))
(define (ripple-carry-adder list-a list-b list-s c)
  (define (ripple-builder la lb ls lcin lcout)
    (if (not (null? la))
	(begin (full-adder (car la) (car lb) (car lcin) (car ls) (car lcout))
	       (ripple-builder (cdr la) (cdr lb) (cdr lcin) (cdr lcout)))))
  (let ((lcin (list)) (lcout (list)))
    (dotimes (length list-a)
	     (lambda () 
	       (let ((w (make-wire)))
		 (set! lcin (append lcin w))
		 (set! lcout (append lcout w)))))
    (set! lcout (append lcout c))
    (ripple-build list-a list-b list-s lcin lcout)))


;; exercise 3.31
;; you need the extra call to intialize the listeners of the current
;; value. and also to ensure that the resulting actions are added to
;; the agenda


;; exercise 3.32
;; the procedures need to be run in order because otherwise the 
;; results would be confused as in the the 1,0;0,1 ordering.
