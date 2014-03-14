;; Q: Ben tried (car '(x y z)) and got an error with our lazy streams.
;; Why? 

;; A: Simple answer '(x y z) is not a lazy list.

;; Q: modify the evaluator to make this work.
(define (text-of-quotation exp env)
  (let ((val (cadr exp)))
    (if (pair? val) (make-lazy-list val env) val)))

(define (make-lazy-list l env)
  (eval (list 'cons (car l) (list 'quote (cdr l))) env))

;; NOTE: not fully tested.
