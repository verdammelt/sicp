;; When we introduced save and restore in section 5.1.4, we didn't
;; specify what would happen if you tried to restore a register that
;; was not the last one saved, as in the sequence

;; (save y)
;; (save x)
;; (restore y)

;; There are several reasonable possibilities for the meaning of
;; restore:

;; a. (restore y) puts into y the last value saved on the stack,
;; regardless of what register that value came from. This is the way
;; our simulator behaves. Show how to take advantage of this behavior
;; to eliminate one instruction from the Fibonacci machine of section
;; 5.1.4 (figure 5.12).

;; In the block starting with label afterfib-n-2 we could replace:
;;
;; (assign n (reg val))
;; (restore val)
;; ...
;; (assign val (op +) (reg n) (reg val)
:;
;; with just:
;;
;; (restore n)
;; ...
;; (assign val (op +) (reg n) (reg val))

;; b. (restore y) puts into y the last value saved on the stack, but
;; only if that value was saved from y; otherwise, it signals an
;; error. Modify the simulator to behave this way. You will have to
;; change save to put the register name on the stack along with the
;; value.

(define (make-stack-element name reg)
  (list name (get-contents reg)))
(define (stack-element-name element)
  (car element))
(define (stack-element-value element)
  (cadr element))
(define (stack-element-is-for-reg? element reg-name)
  (eq (stack-element-name element) reg-name))

(define (make-save inst machine stack pc)
  (let ((reg-name (stack-inst-reg-name inst)))
    (let ((reg (get-register machine reg-name)))
      (lambda ()
	(push stack (make-stack-element reg-name reg))
	(advance-pc pc)))))

(define (make-restore inst machine stack pc)
  (let ((reg-name (stack-inst-reg-name inst)))
   (let ((reg (get-register machine reg-name)))
     (lambda ()
       (let ((stack-element (pop stack)))
	 (if (not (stack-element-is-for-reg?))
	     (error "Cannot restore stack value for wrong register")))
       (set-contents! reg (pop stack))    
       (advance-pc pc)))))


;; c. (restore y) puts into y the last value saved from y regardless
;; of what other registers were saved after y and not restored. Modify
;; the simulator to behave this way. You will have to associate a
;; separate stack with each register. You should make the
;; initialize-stack operation initialize all the register stacks.
(define (make-register name)
  (let ((contents '*unassigned*)
	(stack (make-stack)))
    (define (dispatch message)
      (cond ((eq? message 'get) contents)
            ((eq? message 'set)
             (lambda (value) (set! contents value)))
	    ((eq? message 'push) 
	     ((stack 'push) contents))
	    ((eq? message 'restore) 
	     (set! contents (stack 'pop)))
            (else
             (error "Unknown request -- REGISTER" message))))
    dispatch))

(define (make-save inst machine stack pc)
  (let ((reg (get-register machine
                           (stack-inst-reg-name inst))))
    (lambda ()
      (reg 'push)
      (advance-pc pc))))

(define (make-restore inst machine stack pc)
  (let ((reg (get-register machine
                           (stack-inst-reg-name inst))))
    (lambda ()
      (reg 'restore)
      (advance-pc pc))))

;; 1. remove the stack parameter being passed around everywhere
;; 2. don't create a stack in the machine
;; 3. snippet of make-new-machine that needs to change
(let ((register-table
       (list (list 'pc pc) (list 'flag flag))))
  (let ((the-ops
	 (list (list 'initialize-stack
		     (lambda () 
		       (map (lambda (s) (stack 'initialize))
			    register-table)))))
	...)))

