;; Augment the simulator to provide for instruction tracing. That is,
;; before each instruction is executed, the simulator should print the
;; text of the instruction. Make the machine model accept trace-on and
;; trace-off messages to turn tracing on and off.

(define (make-new-machine)
  (let ((pc (make-register 'pc))
        (flag (make-register 'flag))
        (stack (make-stack))
        (the-instruction-sequence '())
	(trace-on #f)
	(instruction-count 0))
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
      (define (execute)
        (let ((insts (get-contents pc)))
          (if (null? insts)
              'done
              (begin
		(if trace-on
		    (begin
		      (display instruction-count)
		      (display "> ")
		      (display (caar insts))
		      (newline)))
                ((instruction-execution-proc (car insts)))
		(set! instruction-count (1+ instruction-count))
                (execute)))))
      (define (dispatch message)
        (cond ((eq? message 'start)
	       (set! instruction-count 0)
               (set-contents! pc the-instruction-sequence)
               (execute))
              ((eq? message 'install-instruction-sequence)
               (lambda (seq) (set! the-instruction-sequence seq)))
              ((eq? message 'allocate-register) allocate-register)
              ((eq? message 'get-register) lookup-register)
              ((eq? message 'install-operations)
               (lambda (ops) (set! the-ops (append the-ops ops))))
              ((eq? message 'stack) stack)
              ((eq? message 'operations) the-ops)
	      ((eq? message 'trace-on) (set! trace-on #t))
	      ((eq? message 'trace-off) (set! trace-on #f))
              (else (error "Unknown request -- MACHINE" message))))
      dispatch)))
