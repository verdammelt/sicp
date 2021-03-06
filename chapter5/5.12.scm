;; The simulator can be used to help determine the data paths required
;; for implementing a machine with a given controller. Extend the
;; assembler to store the following information in the machine model:

;; * a list of all instructions, with duplicates removed, sorted by
;; instruction type (assign, goto, and so on);

;; * a list (without duplicates) of the registers used to hold entry
;; points (these are the registers referenced by goto instructions);

;; * a list (without duplicates) of the registers that are saved or
;; restored;

;; * for each register, a list (without duplicates) of the sources
;; from which it is assigned (for example, the sources for register
;; val in the factorial machine of figure 5.11 are (const 1) and ((op
;; *) (reg n) (reg val))).

;; Extend the message-passing interface to the machine to provide
;; access to this new information. To test your analyzer, define the
;; Fibonacci machine from figure 5.12 and examine the lists you
;; constructed.

;; Test code
(define test-machine 
  (make-machine 
   '(n val continue) 
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


;; New/Modified code
(define (add-to-assoc-uniquely key value alist)
  (let* ((current-assoc (assoc key alist))
	 (current-values (if current-assoc (cadr current-assoc) '())))
    (if (not (member value current-values))
	(cons (list key (cons value current-values)) alist)
	alist)))

(define (add-to-list-uniquely item l)
  (if (not (member item l))
      (cons item l)
      l))

(define (make-new-machine)
  (let ((pc (make-register 'pc))
        (flag (make-register 'flag))
        (stack (make-stack))
        (the-instruction-sequence '())
	(all-instructions '())
	(entry-point-registers '())
	(stack-registers '())
	(registers-assigned-from '()))
    (let ((the-ops
           (list (list 'initialize-stack
                       (lambda () (stack 'initialize)))
                 ;;**next for monitored stack (as in section 5.2.4)
                 ;;  -- comment out if not wanted
                 (list 'print-stack-statistics
                       (lambda () (stack 'print-statistics)))))
          (register-table
           (list (list 'pc pc) (list 'flag flag))))
      (define (add-instruction inst)
	(set! all-instructions 
	      (add-to-assoc-uniquely (car inst) inst all-instructions)))
      (define (add-entry-point-register reg-name)
	(set! entry-point-registers 
	      (add-to-list-uniquely reg-name entry-point-registers)))
      (define (add-stack-register reg-name)
	(set! stack-registers
	      (add-to-list-uniquely reg-name stack-registers)))
      (define (add-register-assigned-from reg-name assign-expr)
	(set! registers-assigned-from
	      (add-to-assoc-uniquely reg-name assign-expr registers-assigned-from)))
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
      (define (install-instruction-sequence seq)
	(set! the-instruction-sequence seq))
      (define (install-operations ops)
	(set! the-ops (append the-ops ops)))
      (define (start)
	(set-contents! pc the-instruction-sequence)
	(execute))
      (define (execute)
        (let ((insts (get-contents pc)))
          (if (null? insts)
              'done
              (begin
                ((instruction-execution-proc (car insts)))
                (execute)))))
      (define (dispatch message)
        (cond ((eq? message 'start) start)
              ((eq? message 'install-instruction-sequence) install-instruction-sequence)
              ((eq? message 'allocate-register) allocate-register)
              ((eq? message 'get-register) lookup-register)
              ((eq? message 'install-operations) install-operations)
              ((eq? message 'stack) stack)
              ((eq? message 'operations) the-ops)
	      ((eq? message 'add-instruction) add-instruction)
	      ((eq? message 'get-all-instructions) all-instructions)
	      ((eq? message 'add-entry-point-register) add-entry-point-register)
	      ((eq? message 'get-entry-point-registers) entry-point-registers)
	      ((eq? message 'add-stack-register) add-stack-register)
	      ((eq? message 'get-stack-registers) stack-registers)
	      ((eq? message 'add-register-assigned-from) add-register-assigned-from)
	      ((eq? message 'get-registers-assigned-from) registers-assigned-from)
              (else (error "Unknown request -- MACHINE" message))))
      dispatch)))

(define (make-execution-procedure inst labels machine
                                  pc flag stack ops)
  ((machine 'add-instruction) inst)
  (cond ((eq? (car inst) 'assign)
         (make-assign inst machine labels ops pc))
        ((eq? (car inst) 'test)
         (make-test inst machine labels ops flag pc))
        ((eq? (car inst) 'branch)
         (make-branch inst machine labels flag pc))
        ((eq? (car inst) 'goto)
         (make-goto inst machine labels pc))
        ((eq? (car inst) 'save)
         (make-save inst machine stack pc))
        ((eq? (car inst) 'restore)
         (make-restore inst machine stack pc))
        ((eq? (car inst) 'perform)
         (make-perform inst machine labels ops pc))
        (else (error "Unknown instruction type -- ASSEMBLE"
                     inst))))


(define (make-goto inst machine labels pc)
  (let ((dest (goto-dest inst)))
    (cond ((label-exp? dest)
           (let ((insts
                  (lookup-label labels
                                (label-exp-label dest))))
             (lambda () (set-contents! pc insts))))
          ((register-exp? dest)
           (let* ((reg-name (register-exp-reg dest)) 
		  (reg (get-register machine reg-name)))
	     ((machine 'add-entry-point-register) reg-name)
             (lambda ()
               (set-contents! pc (get-contents reg)))))
          (else (error "Bad GOTO instruction -- ASSEMBLE"
                       inst)))))

(define (make-save inst machine stack pc)
  (let* ((reg-name (stack-inst-reg-name inst)) 
	 (reg (get-register machine reg-name)))
    ((machine 'add-stack-register) reg-name)
    (lambda ()
      (push stack (get-contents reg))
      (advance-pc pc))))

(define (make-restore inst machine stack pc)
  (let* ((reg-name (stack-inst-reg-name inst)) 
	 (reg (get-register machine reg-name)))
    ((machine 'add-stack-register) reg-name)
    (lambda ()
      (set-contents! reg (pop stack))    
      (advance-pc pc))))


(define (make-assign inst machine labels operations pc)
  (let* ((reg-name (assign-reg-name inst)) 
	 (target (get-register machine reg-name))
	 (value-exp (assign-value-exp inst)))
    ((machine 'add-register-assigned-from) reg-name value-exp)
    (let ((value-proc
           (if (operation-exp? value-exp)
               (make-operation-exp
                value-exp machine labels operations)
               (make-primitive-exp
                (car value-exp) machine labels))))
      (lambda ()                ; execution procedure for assign
        (set-contents! target (value-proc))
        (advance-pc pc)))))
