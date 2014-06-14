(load "pprint-compile.scm")

(set! label-counter 0)
(pprint-compile "factorial-iter"
		(compile '(define (factorial n)
			    (define (iter product counter)
			      (if (> counter n)
				  product
				  (iter (* counter product)
					(+ counter 1))))
			    (iter 1 1))
			 'val 'next))

;; NEEDS: (env)
;; MODIFIES: (val)
;; STATEMENTS:
;; (assign val (op make-compiled-procedure) (label entry2) (reg env))
;; (goto (label after-lambda1))
;; entry2					; entry for factorial
;; (assign env (op compiled-procedure-env) (reg proc))
;; (assign env (op extend-environment) (const (n)) (reg argl) (reg env))
;; (assign val (op make-compiled-procedure) (label entry7) (reg env))
;; (goto (label after-lambda6))
;; entry7					; entry for iter
;; (assign env (op compiled-procedure-env) (reg proc))
;; (assign env (op extend-environment) (const (product counter)) (reg argl) (reg env))
;; (save continue)
;; (save env)
;; (assign proc (op lookup-variable-value) (const >) (reg env)) ;execute (> counter n)
;; (assign val (op lookup-variable-value) (const n) (reg env))
;; (assign argl (op list) (reg val))
;; (assign val (op lookup-variable-value) (const counter) (reg env))
;; (assign argl (op cons) (reg val) (reg argl))
;; (test (op primitive-procedure?) (reg proc))
;; (branch (label primitive-branch22))
;; compiled-branch21
;; (assign continue (label after-call20))
;; (assign val (op compiled-procedure-entry) (reg proc))
;; (goto (reg val))
;; primitive-branch22
;; (assign val (op apply-primitive-procedure) (reg proc) (reg argl))
;; after-call20
;; (restore env)
;; (restore continue)
;; (test (op false?) (reg val))		; if statement
;; (branch (label false-branch9))
;; true-branch10
;; (assign val (op lookup-variable-value) (const product) (reg env))
;; (goto (reg continue))
;; false-branch9
;; (assign proc (op lookup-variable-value) (const iter) (reg env)) ; begin recursive call
;; (save continue)
;; (save proc)
;; (save env)
;; (assign proc (op lookup-variable-value) (const +) (reg env)) ; (+ counter 1)
;; (assign val (const 1))
;; (assign argl (op list) (reg val))
;; (assign val (op lookup-variable-value) (const counter) (reg env))
;; (assign argl (op cons) (reg val) (reg argl))
;; (test (op primitive-procedure?) (reg proc))
;; (branch (label primitive-branch16))
;; compiled-branch15
;; (assign continue (label after-call14))
;; (assign val (op compiled-procedure-entry) (reg proc))
;; (goto (reg val))
;; primitive-branch16
;; (assign val (op apply-primitive-procedure) (reg proc) (reg argl))
;; after-call14				;done (+...)
;; (assign argl (op list) (reg val))
;; (restore env)
;; (save argl)
;; (assign proc (op lookup-variable-value) (const *) (reg env)) ; (* counter product)
;; (assign val (op lookup-variable-value) (const product) (reg env))
;; (assign argl (op list) (reg val))
;; (assign val (op lookup-variable-value) (const counter) (reg env))
;; (assign argl (op cons) (reg val) (reg argl))
;; (test (op primitive-procedure?) (reg proc))
;; (branch (label primitive-branch13))
;; compiled-branch12
;; (assign continue (label after-call11))
;; (assign val (op compiled-procedure-entry) (reg proc))
;; (goto (reg val))
;; primitive-branch13
;; (assign val (op apply-primitive-procedure) (reg proc) (reg argl))
;; after-call11				;done (*...)
;; (restore argl)
;; (assign argl (op cons) (reg val) (reg argl))
;; (restore proc)
;; (restore continue)
;; (test (op primitive-procedure?) (reg proc)) ; actually executing recursive call
;; (branch (label primitive-branch19))
;; compiled-branch18
;; (assign val (op compiled-procedure-entry) (reg proc))
;; (goto (reg val))
;; primitive-branch19
;; (assign val (op apply-primitive-procedure) (reg proc) (reg argl))
;; (goto (reg continue))
;; after-call17				;done recursive
;; after-if8
;; after-lambda6
;; (perform (op define-variable!) (const iter) (reg val) (reg env))
;; (assign val (const ok))
;; (assign proc (op lookup-variable-value) (const iter) (reg env)) ; initial call (iter 1 1)
;; (assign val (const 1))
;; (assign argl (op list) (reg val))
;; (assign val (const 1))
;; (assign argl (op cons) (reg val) (reg argl))
;; (test (op primitive-procedure?) (reg proc))
;; (branch (label primitive-branch5))
;; compiled-branch4
;; (assign val (op compiled-procedure-entry) (reg proc))
;; (goto (reg val))
;; primitive-branch5
;; (assign val (op apply-primitive-procedure) (reg proc) (reg argl))
;; (goto (reg continue))
;; after-call3
;; after-lambda1
;; (perform (op define-variable!) (const factorial) (reg val) (reg env))
;; (assign val (const ok))

;; Comparing this with the compilation of the 'normal' factorial shows
;; the different. Here - after the recursive call is complete the
;; execution of the procedure is done. In the 'normal' version we
;; still need to execute the * operation (and possibly evaluate n -
;; depending on wether it is (* n (fact...)) or (* (fact...) n). This
;; means more pushing onto the stack - these will not be popped off
;; until everything is complete.

