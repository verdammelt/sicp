;; from the book
(define (no-operands? ops) (null? ops))
(define (first-operand ops) (car ops))
(define (rest-operands ops) (cdr ops))
(define (list-of-values exps env)
  (if (no-operands? exps)
      '()
      (cons (eval (first-operand exps) env)
            (list-of-values (rest-operands exps) env))))

;; exercise 4.1
;; list-of-values does not define the order of evaluation, it has the
;; same order as the underlying lisp (in the cons).
;; define a version that has strict left-to-right evaluation and one 
;; that has strict right-to-left evaluation
(define (lr-list-of-values exps env)
  (if (no-operands? exps) 
      '()
      ;; using nested let to make sure we get the ordering right.
      (let ((first (my-eval (first-operand exps) env)))
	(let ((rest (lr-list-of-values (rest-operands exps) env)))
	  (cons first rest)))))
(define (rl-list-of-values exps env)
  (if (no-operands? exps) 
      '()
      ;; using nested let to make sure we get the ordering right.
      (let ((rest (rl-list-of-values (rest-operands exps) env)))
	(let ((first (my-eval (first-operand exps) env)))
	  (cons first rest)))))

;; for testing.
(define (my-eval exp env)
  (let ((evaled (list 'eval exp env)))
    (begin
      (display evaled)
      evaled)))



