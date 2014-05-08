;; create an if-fail which takes two arguments. If the first
;; argument succeeds it returns as normal. If the first argument fails
;; then it returns the second argument.
(define (if-fail? exp) (tagged-list? exp 'if-fail))
(define (if-fail-predicate exp) (cadr exp))
(define (if-fail-alternate exp) (caddr exp))
(define (analyze-if-fail exp)
  (display 'analyze-if-fail)
  (let ((pproc (analyze (if-fail-predicate exp)))
	(aproc (analyze (if-fail-alternate exp))))
    (lambda (env succeed fail)
      (pproc env 
	     succeed
	     (lambda ()
	       (aproc env succeed fail))))))

(define (analyze exp)
  (cond ((self-evaluating? exp) 
         (analyze-self-evaluating exp))
        ((quoted? exp) (analyze-quoted exp))
        ((variable? exp) (analyze-variable exp))
        ((assignment? exp) (analyze-assignment exp))
        ((definition? exp) (analyze-definition exp))
        ((if? exp) (analyze-if exp))
	((if-fail? exp) (analyze-if-fail exp))
        ((lambda? exp) (analyze-lambda exp))
        ((begin? exp) (analyze-sequence (begin-actions exp)))
        ((cond? exp) (analyze (cond->if exp)))
        ((let? exp) (analyze (let->combination exp))) ;**
        ((amb? exp) (analyze-amb exp))                ;**
        ((application? exp) (analyze-application exp))
        (else
         (error "Unknown expression type -- ANALYZE" exp))))

;;; Code for the amb interpreter:
;; (define (require p)
;;  (if (not p) (amb)))
;; (define (even? n)
;;   (eq? (remainder n 2) 0))
;; (define (an-element-of items)
;;   (require (not (null? items)))
;;   (amb (car items) (an-element-of (cdr items))))

;; From the book - example of use of if-fail
;;; Amb-Eval input:
;; (if-fail 
;;  (let ((x (an-element-of '(1 3 5)))) 
;;    (require (even? x))
;;    x)
;;  'all-odd)
;;; Starting a new problem
;;; Amb-Eval value:
;; all-odd
;;; Amb-Eval input:
;; (if-fail (let ((x (an-element-of '(1 3 5 8))))
;; 	   (require (even? x))
;; 	   x)
;; 	 'all-odd)
;;; Starting a new problem
;;; Amb-Eval value:
;; 8
