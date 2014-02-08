;; to show power of data-driven programming - change syntax of the
;; scheme we are interpretting. without changing eval.
;;
;; as purely an example lets change (define (fn args)...) to (def fn (args) ...)
;; and (define var val) to (def var val)
;; and (set! var val) to (setq var val)
(define (assignment? exp) (tagged-list? exp 'setq))

(define (definition? exp) (tagged-list? exp 'def))
(define (definition-variable exp) (cadr exp))
(define (definition-value exp)
  (cond ((eq? (length exp) 4) (make-lambda (caddr exp) (cdddr exp)))
	((eq? (length exp) 3) (caddr exp))
	(else (error "Invalid DEF syntax"))))

