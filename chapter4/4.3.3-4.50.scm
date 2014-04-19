;; implement special form ramb which is like amb except it picks the
;; next choice at random rather than left-to-right.

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
        ((let? exp) (analyze (let->combination exp))) ;**
	((ramb? exp) (analyze-ramb exp)) 
        ((amb? exp) (analyze-amb exp))                ;**
        ((application? exp) (analyze-application exp))
        (else
         (error "Unknown expression type -- ANALYZE" exp))))

(define (ramb? exp) (tagged-list? exp 'ramb))

(define (choose-at-random choices)
  (let ((idx (random (length choices))))
    (let ((choice (list-ref choices idx)))
      (cons choice (delete choice choices)))))

(define (analyze-ramb exp)
  (let ((cprocs (map analyze (amb-choices exp))))
    (lambda (env succeed fail)
      (define (try-next choices) ;; need to change this to do it random
	(if (null? choices)
	    (fail)
	    (let ((pick (choose-at-random choices)))
	      ((car pick) env succeed (lambda () (try-next (cdr pick)))))))
      (try-next cprocs))))

;; (define (test)
;;   (let ((choice (ramb 1 2 3 4 5)))
;;     (display choice)
;;     (newline)))
