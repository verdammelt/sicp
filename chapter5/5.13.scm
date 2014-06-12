;; Modify the simulator so that it uses the controller sequence to
;; determine what registers the machine has rather than requiring a
;; list of registers as an argument to make-machine. Instead of pre-
;; allocating the registers in make-machine, you can allocate them one
;; at a time when they are first seen during assembly of the
;; instructions.

(define make-test-machine 
  (lambda ()  
    (make-machine 
     ;; '(n val continue) 
     (list (list '< <) (list '- -) (list '+ +))
     '(controller
       (assign continue (label fib-done))
       fib-loop
       (test (op <) (reg n) (const 2))
       (branch (label immediate-answer))
       (save continue)
       (assign continue (label afterfib-n-1))
       (save n)
       (assign n (op -) (reg n) (const 1))
       (goto (label fib-loop))
       afterfib-n-1 
       (restore n)
       (restore continue)
       (assign n (op -) (reg n) (const 2))
       (save continue)
       (assign continue (label afterfib-n-2))
       (save val)
       (goto (label fib-loop))
       afterfib-n-2
       (assign n (reg val))
       (restore val)
       (restore continue)
       (assign val (op +) (reg val) (reg n))
       (goto (reg continue))
       immediate-answer
       (assign val (reg n))
       (goto (reg continue))
       fib-done)))
  )

(define (make-machine ops controller-text)
  (let ((machine (make-new-machine)))
    ;; (for-each (lambda (register-name)
    ;;             ((machine 'allocate-register) register-name))
    ;;           register-names)
    ((machine 'install-operations) ops)    
    ((machine 'install-instruction-sequence)
     (assemble controller-text machine))
    machine))


(define (make-new-machine)
  (let ((pc (make-register 'pc))
        (flag (make-register 'flag))
        (stack (make-stack))
        (the-instruction-sequence '()))
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
	      (begin (allocate-register name) (lookup-register name)))))
      (define (execute)
        (let ((insts (get-contents pc)))
          (if (null? insts)
              'done
              (begin
                ((instruction-execution-proc (car insts)))
                (execute)))))
      (define (dispatch message)
        (cond ((eq? message 'start)
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
	      ((eq? message 'get-register-table) register-table)
              (else (error "Unknown request -- MACHINE" message))))
      dispatch)))
