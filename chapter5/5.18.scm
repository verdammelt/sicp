;; Modify the make-register procedure of section 5.2.1 so that
;; registers can be traced. Registers should accept messages that turn
;; tracing on and off. When a register is traced, assigning a value to
;; the register should print the name of the register, the old
;; contents of the register, and the new contents being assigned.
;; Extend the interface to the machine model to permit you to turn
;; tracing on and off for designated machine registers.


(define (make-register name)
  (let ((contents '*unassigned*)
	(trace-on #f))
    (define (dispatch message)
      (cond ((eq? message 'get) contents)
            ((eq? message 'set)
             (lambda (value) 
	       (let ((old-value contents))
		 (if trace-on
		     (display "SET REGISTER (old=")
		     (display old-value)
		     (display ") (new=")
		     (display value)
		     (display ")")
		     (newline))
		 (set! contents value))))
	    ((eq? message 'trace-on) (set! trace-on #t))
	    ((eq? message 'trace-off) (set! trace-on #f))
            (else
             (error "Unknown request -- REGISTER" message))))
    dispatch))
