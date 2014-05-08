;; With permanent-set! as described in exercise 4.51 and if-fail as in exercise 4.52,
;; what will be the result of evaluating
;; (let ((pairs '()))
;;   (if-fail (let ((p (prime-sum-pair '(1 3 5 8) '(20 35 110))))
;; 	     (permanent-set! pairs (cons p pairs))
;; 	     (amb))
;; 	   pairs))

;; Given that the following items defined already in the interpreter:
;; (define (require p)
;;  (if (not p) (amb)))
;; (define (an-element-of items)
;;   (require (not (null? items)))
;;   (amb (car items) (an-element-of (cdr items))))
;; (define (prime-sum-pair list1 list2)
;;   (let ((a (an-element-of list1))
;; 	(b (an-element-of list2)))
;;     (require (prime? (+ a b)))
;;     (list a b)))
;; (define (prime? n) 
;;   (= n (smallest-divisor n)))
;; (define (smallest-divisor n)
;;   (find-divisor n 2))
;; (define (square n) (* n n ))
;; (define (find-divisor n test-divisor)
;;   (cond ((> (square test-divisor) n) n)
;; 	((divides? test-divisor n) test-divisor)
;; 	(else (find-divisor n (+ test-divisor 1)))))
;; (define (divides? a b)
;;   (= (remainder b a) 0))

;; and the following changes to the analyze function of the interpreter have been done:
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

(define (assignment? exp)
  (or (tagged-list? exp 'set!)
      (tagged-list? exp 'permanent-set!)))

(define (analyze-assignment exp)
  (let ((var (assignment-variable exp))
        (vproc (analyze (assignment-value exp)))
	(permanent? (tagged-list? exp 'permanent-set!)))
    (lambda (env succeed fail)
      (vproc env
             (lambda (val fail2)        ; *1*
               (let ((old-value
                      (lookup-variable-value var env))) 
                 (set-variable-value! var val env)
                 (succeed 'ok
                          (lambda ()    ; *2*
			    (if (not permanent?)
				(set-variable-value! var
						     old-value
						     env))
			    (fail2)))))
             fail))))

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

