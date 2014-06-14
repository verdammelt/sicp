;; What was compiled to produce this?

(assign val (op make-compiled-procedure) (label entry16) (goto (label after-lambda15))
entry16
(reg env))
(assign env (op compiled-procedure-env) (reg proc))
(assign env (op extend-environment) (const (x)) (reg argl) (reg env))
(assign proc (op lookup-variable-value) (const +) (reg env)) ; f1 +
(save continue)
(save proc)
(save env)
(assign proc (op lookup-variable-value) (const g) (reg env)) ; f2 g
(save proc)
(assign proc (op lookup-variable-value) (const +) (reg env)) ; f3 +
(assign val (const 2))
(assign argl (op list) (reg val))	;arg for f3
(assign val (op lookup-variable-value) (const x) (reg env))
(assign argl (op cons) (reg val) (reg argl)) ; arg for f3
(test (op primitive-procedure?) (reg proc)) ; start f3
(branch (label primitive-branch19))
compiled-branch18
(assign continue (label after-call17))
(assign val (op compiled-procedure-entry) (reg proc))
(goto (reg val))
primitive-branch19
(assign val (op apply-primitive-procedure) (reg proc) (reg argl))
after-call17				;done f3
(assign argl (op list) (reg val))	; arg for f2
(restore proc)
(test (op primitive-procedure?) (reg proc)) ; start f2
(branch (label primitive-branch22))
compiled-branch21
(assign continue (label after-call20))
(assign val (op compiled-procedure-entry) (reg proc))
(goto (reg val))
primitive-branch22
(assign val (op apply-primitive-procedure) (reg proc) (reg argl))
after-call20				; done f2
(assign argl (op list) (reg val))	; arg for f1
(restore env)
(assign val (op lookup-variable-value) (const x) (reg env))
(assign argl (op cons) (reg val) (reg argl)) ; arg for f1
(restore proc)
(restore continue)
(test (op primitive-procedure?) (reg proc)) ; start f1
(branch (label primitive-branch25))
compiled-branch24
(assign val (op compiled-procedure-entry) (reg proc))
(goto (reg val))
primitive-branch25
(assign val (op apply-primitive-procedure) (reg proc) (reg argl))
(goto (reg continue))
after-call23				;done f1
after-lambda15
(perform (op define-variable!) (const f) (reg val) (reg env))
(assign val (const ok))

;; that appears to be the compilation of:

(define (f x)
  (+ x (g (+ 2 x))))
