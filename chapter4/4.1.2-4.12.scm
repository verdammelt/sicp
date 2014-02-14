;; redefine set-variable-value!, define-variable! and
;; lookup-variable-value based upon 'more abstract procedures'

(define (scan-for-var var if-found if-not-found frame)
  (define (scan var vars vals)
    (cond ((null? vars) (if-not-found))
	  ((eq? var (car vars)) (if-found vals))
	  (else (scan (cdr vars) (cdr vals)))))
  (scan var (frame-variables frame) (frame-values frame)))

(define (env-loop var if-found env)
  (if (eq? env the-empty-environment) 
      (error "unbound variable" var)
      (scan-for-var 
       var
       (lambda () (env-loop var if-found (enclosing-environment env)))
       (lambda (vals) (if-found vals))
       (first-frame env))))

(define (define-variable! var val env)
  (scan-for-var 
   var 
   (lambda () (add-binding-to-frame! var val frame))
   (lambda (vals) (set-car! vals val))
   (first-frame env)))

(define (lookup-variable-value var env)
  (env-loop var car env))

(define (set-variable-value! var val env)
  (env-loop var (lambda (vals) (set-car! vals val)) env))


