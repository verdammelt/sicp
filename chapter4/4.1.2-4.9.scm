;; implement iteration constructs like do, for, while, until
;; show how to use them and implement them as derived expresssions.

;; (for x in '(a b c) (display x)) => c (prints a\nb\nc\n)
;; (while pred body)
;; (until pred body)

;; (for x in list body) ==> 
;; ((lambda (x) 
;;    (begin body 
;; 	  (if (null (cdr list)) x
;; 	      (for x in (cdr list) body)))) 
;;  (car list))

;; (while pred body) ==>
;; (if pred (begin body (while pred body)))

;; (until pred body) ==>
;; (if pred '() (begin body (until pred body)))

(define (for? exp) (eq? (car exp) 'for))
(define (for-var exp) (cadr exp))
(define (for-list exp) (cadddr exp))
(define (for-body exp) (car (cddddr exp)))
(define (make-for var values body) (list 'for var 'in values body))
(define (for->combination exp env)
  (let ((values (eval (for-list exp) env)))
    (cons (make-lambda (list (for-var exp)) 
		       (list 
			(cond ((null? (cdr values)) 
			       (for-body exp)) 
			      (else 
			       (make-begin 
				(list (for-body exp)
				      (make-for (for-var exp) 
						(list 'quote (cdr values))
						(for-body exp))))))))
	  (list (car values)))))

(define (while? exp) (eq? (car exp) 'while))
(define (while-pred exp) (cadr exp))
(define (while-body exp) (caddr exp))
(define (make-while pred body) (list 'while pred body))
(define (while->combination exp)
  (make-if (while-pred exp) 
	   (make-begin (list (while-body exp) exp)) 
	   '()))

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
	((for? exp) (eval (for->combination exp env) env))
	((while? exp) (eval (while->combination exp) env))
        ((application? exp)
         (apply (eval (operator exp) env)
                (list-of-values (operands exp) env)))
        (else
         (error "Unknown expression type -- EVAL" exp))))
