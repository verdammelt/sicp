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

;; exercise 4.3
;; Rewrite eval in data driven style (a la exercise 2.73)

(define (dd-eval exp env)
  (cond ((self-evaluating? exp) exp)
        ((variable? exp) (lookup-variable-value exp env))
        ((quoted? exp) (text-of-quotation exp))
	((not (null? (get 'eval (car exp)))) ((get 'eval (car exp)) exp env))
        ;; ((assignment? exp) (eval-assignment exp env))
        ;; ((definition? exp) (eval-definition exp env))
        ;; ((if? exp) (eval-if exp env))
        ;; ((lambda? exp)
        ;;  (make-procedure (lambda-parameters exp)
        ;;                  (lambda-body exp)
        ;;                  env))
        ;; ((begin? exp) 
        ;;  (eval-sequence (begin-actions exp) env))
        ;; ((cond? exp) (eval (cond->if exp) env))

	;; decided not to do what louis was doing.
        ((application? exp)
          (apply (eval (operator exp) env)
                 (list-of-values (operands exp) env)))
         (else
          (error "Unknown expression type -- EVAL" exp))
	))

(define (install-eval-package)
  (put 'eval 'set! eval-assignment)
  (put 'eval 'define eval-definition)
  (put 'eval 'if eval-if)
  (put 'eval 'lambda (lambda (exp env)
		       (make-procedure (lambda-parameters exp)
				       (lambda-body exp)
				       env)))
  (put 'eval 'begin eval-sequence)
  (put 'eval 'cond (lambda (exp env)
		     (eval (cond->if exp) env))))

;; snagged off the Interwebs:
(define *op-table* (make-hash-table))
(define (put op type proc)
  (hash-table/put! *op-table* (list op type) proc))
(define (get op type)
  (hash-table/get *op-table* (list op type) '()))

;; exercise 4.4
;; create new special forms and and or
;; (or define them as derived expressions)
(define (eval-with-andor exp env)
  (cond ((self-evaluating? exp) exp)
        ((variable? exp) (lookup-variable-value exp env))
        ((quoted? exp) (text-of-quotation exp))
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
	((and? exp) (eval-and (and-arguments exp) env))
	((or? exp) (eval-or (or-arguments exp) env))
        ((application? exp)
         (apply (eval (operator exp) env)
                (list-of-values (operands exp) env)))
        (else
         (error "Unknown expression type -- EVAL" exp))))

(define (and? exp) (tagged-list? exp 'and))
(define (and-arguments exp) (cdr exp))
(define (eval-and exps env)
  (pp (list 'eval-and exps 'env))
  (cond ((no-operands? exps) true)
	((eval (first-operand exps) env)
	 (eval-and (rest-operands exps) env))
	(else false)))

(define (or? exp) (tagged-list? exp 'or))
(define (or-arguments exp) (cdr exp))
(define (eval-or exps env)
  (pp (list 'eval-or exps 'env))
  (cond ((no-operands? exps) false)
	((eval (first-operand exps) env) true)
	(else (eval-or (rest-operands exps) env))))

