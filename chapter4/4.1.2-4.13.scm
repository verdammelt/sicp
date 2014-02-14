;; define a make-unbound!
;; should it remove just the latest binding or all bindings?
;; the answer will be 'yes'. There will be a make-unbound! and make-all-unbound!

;; using code from exercise 4.12

(define (noop) nil)

(define (remove-top-binding! vars vals)
  (set-cdr! vars (cddr vars))
  (set-cdr! vals (cddr vals)))

(define (make-unbound! var env)
  (env-loop var remove-top-binding! env))

(define (make-all-unbound! var env)
  (if (eq? env the-empty-environment) nil
      (scan-for-var
       var
       (lambda () (make-all-unbound! var (enclosing-environment env)))
       remove-top-binding!
       (first-frame env))))
