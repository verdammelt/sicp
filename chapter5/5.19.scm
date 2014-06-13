;; Alyssa P. Hacker wants a breakpoint feature in the simulator to
;; help her debug her machine designs. You have been hired to install
;; this feature for her. She wants to be able to specify a place in
;; the controller sequence where the simulator will stop and allow 
;; to examine the state of the machine. You are to implement a procedure

;; (set-breakpoint <machine> <label> <n>)

;; that sets a breakpoint just before the nth instruction after the
;; given label. For example,

;; (set-breakpoint gcd-machine 'test-b 4)

;; installs a breakpoint in gcd-machine just before the assignment to
;; register a. When the simulator reaches the breakpoint it should
;; print the label and the offset of the breakpoint and stop executing
;; instructions. Alyssa can then use get-register-contents and
;; set-register-contents! to manipulate the state of the simulated
;; machine. She should then be able to continue execution by saying

;; (proceed-machine <machine>)

;; She should also be able to remove a specific breakpoint by means of 

;; (cancel-breakpoint <machine> <label> <n>)

;; or to remove all breakpoints by means of 

;; (cancel-all-breakpoints <machine>)


(define (make-new-machine)
  (let ((pc (make-register 'pc))
        (flag (make-register 'flag))
        (stack (make-stack))
        (the-instruction-sequence '())
	(breakpoints '()))
    (let ((the-ops
           (list (list 'initialize-stack
                       (lambda () (stack 'initialize)))
                 ;;**next for monitored stack (as in section 5.2.4)
                 ;;  -- comment out if not wanted
                 (list 'print-stack-statistics
                       (lambda () (stack 'print-statistics)))))
          (register-table
           (list (list 'pc pc) (list 'flag flag))))
      (define (allocate-register name)
        (if (assoc name register-table)
            (error "Multiply defined register: " name)
            (set! register-table
                  (cons (list name (make-register name))
                        register-table)))
        'register-allocated)
      (define (lookup-register name)
        (let ((val (assoc name register-table)))
          (if val
              (cadr val)
              (error "Unknown register:" name))))
      (define (execute proceed?)
        (let ((insts (get-contents pc)))
          (if (null? insts)
              'done
	      (let* ((inst (car insts))
		     (inst-text (instruction-text inst))
		     (breakpoint (assoc inst-text breakpoints)))
		(if (and breakpoint (not proceed?))
		    (begin
		      (display "BREAKPOINT<")
		      (display (cadr breakpoint))
		      (display ">: ")
		      (display inst-text)
		      (newline)
		      'stopped)
		    (begin
		      ((instruction-execution-proc inst))
		      (execute #f)))))))

      (define (set-breakpoint label n) 
	(set! breakpoints 
	      (cons (list (instruction-text 
			   (list-ref the-instruction-sequence 
				     (- n 1)))
			  (list label n))
		    breakpoints))
	'breakpoint-set)
      (define (proceed-machine) (execute #t))
      (define (cancel-breakpoint label n) 'noop)
      (define (cancel-all-breakpoints) 'noop)

      (define (dispatch message)
        (cond ((eq? message 'start)
               (set-contents! pc the-instruction-sequence)
               (execute #f))
              ((eq? message 'install-instruction-sequence)
               (lambda (seq) (set! the-instruction-sequence seq)))
              ((eq? message 'allocate-register) allocate-register)
              ((eq? message 'get-register) lookup-register)
              ((eq? message 'install-operations)
               (lambda (ops) (set! the-ops (append the-ops ops))))
              ((eq? message 'stack) stack)
              ((eq? message 'operations) the-ops)

	      ((eq? message 'set-breakpoint) set-breakpoint)
	      ((eq? message 'proceed-machine) proceed-machine)
	      ((eq? message 'cancel-breakpoint) cancel-breakpoint)
	      ((eq? message 'cancel-all-breakpoints) cancel-all-breakpoints)

              (else (error "Unknown request -- MACHINE" message))))
      dispatch)))

(define (set-breakpoint machine label n)
  ((machine 'set-breakpoint) label n))
(define (proceed-machine machine) 
  ((machine 'proceed-machine)))
(define (cancel-breakpoint machine label n)
  ((machine 'cancel-breakpoint) label n))
(define (cancel-all-breakpoints machine)
  ((machine 'cancel-all-breakpoints)))

(define gcd-machine
  (make-machine
   '(a b t)
   (list (list 'rem remainder) (list '= =))
   '(test-b
       (test (op =) (reg b) (const 0))
       (branch (label gcd-done))
       (assign t (op rem) (reg a) (reg b))
       (assign a (reg b))
       (assign b (reg t))
       (goto (label test-b))
     gcd-done)))

(define (run-test)
  (set-register-contents! gcd-machine 'a 20)
  (set-register-contents! gcd-machine 'b 40)
  (start gcd-machine))
