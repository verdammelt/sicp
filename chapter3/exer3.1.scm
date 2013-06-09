;; exercise 3.1
(define (make-accumulator value)
  (lambda (n) 
    (set! value (+ n value))
    value))

;; exercise 3.2
(define (make-monitored fn)
  (let ((num-calls 0))
    (lambda (arg)
      (cond ((eq? arg 'how-many-calls?) num-calls)
	    ((eq? arg 'reset-count) (begin (set! num-calls 0) num-calls))
	    (else (begin (set! num-calls (1+ num-calls)) (fn arg)))))))



