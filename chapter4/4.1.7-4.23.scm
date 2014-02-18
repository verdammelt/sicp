;; original analyze-sequnece
(define (orig-analyze-sequence exps)
  (define (sequentially proc1 proc2)
    (pp 'sequentially)
    (pp proc1)
    (pp proc2)
    (lambda (env) (proc1 env) (proc2 env)))
  (define (loop first-proc rest-procs)
    (if (null? rest-procs)
        first-proc
        (loop (sequentially first-proc (car rest-procs))
		(cdr rest-procs))))
  (let ((procs (map analyze exps)))
    (if (null? procs)
        (error "Empty sequence -- ANALYZE"))
    (loop (car procs) (cdr procs))))

;; Alyssa's version of analyze-sequnece
(define (alyssa-analyze-sequence exps)
  (define (execute-sequence procs env)
    (pp 'execute-sequence)
    (pp procs)
    (cond ((null? (cdr procs)) ((car procs) env))
	  (else ((car procs) env)
		(execute-sequence (cdr procs) env))))
  (let ((procs (map analyze exps)))
    (if (null? procs)
	(error "Empty sequence -- ANALYZE"))
    (lambda (env) (execute-sequence procs env))))

;; Eva says Alyssa's version doesn't do as much work during analyze
;; phase - very true.
;;
;; compare the two versions with for example a sequence of one
;; expression:
;;
;; With one expression the original will evaluate the analyzed
;; expression.  Alyssa's will evaluate a function which will then
;; execute the analyzed expression when it realizes that there is only
;; one. A slight amount of extra overhead for the function call and
;; the check-and-branch.
;;
;; compare with two expressions:
;; 
;; The original will evaluate an procedure which executes the two
;; analyzed expressions.  Alyssa's will evaluate a procedure which
;; will execute the first analyzed expression and then recurse with
;; the second expression and seeing that there is only one left,
;; execute it.
;;
;; The original does more work up front during hte analyze step so
;; that evaluation is just executing the procedures in the correct
;; environment.

