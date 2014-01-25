(define (eval exp env)
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
	((let? exp) (eval (let->combination exp) env))
        ((application? exp)
         (apply (eval (operator exp) env)
                (list-of-values (operands exp) env)))
        (else
         (error "Unknown expression type -- EVAL" exp))))

(define (let? exp) (tagged-list? exp 'let))
(define (named-let? exp) (eq? (length exp) 4))
(define (let-name exp)
  (if (named-let? exp) (cadr exp) 'unnamed-let))
(define (let-bindings exp) 
  (if (named-let? exp) (caddr exp) (cadr exp)))
(define (let-variables exp)
  (map car (let-bindings exp)))
(define (let-values exp)
  (map cadr (let-bindings exp)))
(define (let-body exp) 
  (if (named-let? exp) (cdddr exp) (cddr exp)))
(define (let->combination exp)
  (if (named-let? exp)
      (list 'begin
	    (list 'define 
		  (let-name exp) 
		  (make-lambda (let-variables exp) (let-body exp)))
	    (cons (let-name exp) (let-values exp)))
      (cons (make-lambda (let-variables exp)
		     (let-body exp))
	(let-values exp))))

;;; test
(set! primitive-procedures
      (append primitive-procedures
	       (list (list '= =)
		     (list '+ +)
		     (list '- -))))
(let ((env (setup-environment)))
    (eval 
     '(begin 
	(define (fib n)
	  (let fib-iter ((a 1)
			 (b 0)
			 (count n))
	    (if (= count 0)
		b
		(fib-iter (+ a b) a (- count 1)))))
	(fib 10))
     env))

