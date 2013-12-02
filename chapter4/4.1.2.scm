;; Louis wants to reorder the COND clauses in EVAL to have all
;; procedure application before assignment.

(define (louis-eval exp env)
  (cond ((self-evaluating? exp) exp)
        ((variable? exp) (lookup-variable-value exp env))
        ((quoted? exp) (text-of-quotation exp))
        ((louis-application? exp)
         (apply (eval (louis-operator exp) env)
                (list-of-values (louis-operands exp) env)))
	((assignment? exp) (eval-assignment exp env))
        ((definition? exp) (eval-definition exp env))
        ((if? exp) (eval-if exp env))
        ((lambda? exp)
         (make-procedure (lambda-parameters exp)
                         (lambda-body exp)
                         env))
        ((begin? exp) 
         (eval-sequence (begin-actions exp) env))
        ((cond? exp) (eval (cond->if exp) env))
        
        (else
         (error "Unknown expression type -- EVAL" exp))))

;; a) what's wrong with this idea (HINT: what happens with: (define x 3))

;; The problem is that an procedure application is recognized because
;; it is simply a pair. If it is moved above all other clauses which
;; filter out things which are pairs but are tagged then all those
;; things will appear to be procedure applications.

;; (define x 3) becomes, not a definition, but a procedure application
;; of the procedure define to the arguents x and 3

;; b) he really wants to make this work. He wants procedure
;; application to start with 'call. So instead of (+ 1 2) do 
;; (call + 1 2). Write the needed code to make this work
(define (louis-application? exp) (tagged-list? exp 'call))
(define (louis-operator exp) (cadr exp))
(define (louis-operands exp) (cddr exp))
