;; (load "analysingmceval.scm")
(define primitive-procedures
  (list (list 'car car)
        (list 'cdr cdr)
        (list 'cons cons)
        (list 'null? null?)
	(list '+ +)
	(list '- -)
;;      more primitives
        ))

;; extend with let form
(define (analyze exp)
  (cond ((self-evaluating? exp) 
         (analyze-self-evaluating exp))
        ((quoted? exp) (analyze-quoted exp))
        ((variable? exp) (analyze-variable exp))
        ((assignment? exp) (analyze-assignment exp))
        ((definition? exp) (analyze-definition exp))
        ((if? exp) (analyze-if exp))
        ((lambda? exp) (analyze-lambda exp))
        ((begin? exp) (analyze-sequence (begin-actions exp)))
        ((cond? exp) (analyze (cond->if exp)))
	((let? exp) (analyze (let->lambda exp)))
        ((application? exp) (analyze-application exp))
        (else
         (error "Unknown expression type -- ANALYZE" exp))))

(define (let? exp) (tagged-list? exp 'let))
(define (let-body exp) (cddr exp))
(define (let-variables exp) (map car (cadr exp)))
(define (let-values exp) (map cadr (cadr exp)))
(define (let->lambda exp)
  (let ((body (let-body exp))
	(vars (let-variables exp))
	(vals (let-values exp)))
    (cons (make-lambda vars body) vals)))

(define let-test-exp '(let ((a 1) (b 2)) (+ a b)))
