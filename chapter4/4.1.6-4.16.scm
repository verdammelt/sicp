;; implement the 'scanning out' of internal definitions as described
;; in the book

; a) change lookup-variable-value to signal error if variable value is
; *unasigned*

(define (lookup-variable-value var env)
  (define (env-loop env)
    (define (scan vars vals)
      (cond ((null? vars)
             (env-loop (enclosing-environment env)))
            ((eq? var (car vars))
             (car vals))
            (else (scan (cdr vars) (cdr vals)))))
    (if (eq? env the-empty-environment)
        (error "Unbound variable" var)
        (let ((frame (first-frame env)))
          (scan (frame-variables frame)
                (frame-values frame)))))
  (let ((value (env-loop env)))
    (if (eq? value '*unassigned*)
	(error "Unassigned variable" var)
	value)))

;; transform something like:
;; (lambda (vars)
;;   (define u e1)
;;   (define v e2)
;;   e3)
;;
;; to 
;; 
;; (lambda (vars)
;;   (let ((u '*unassigned*)
;; 	(v '*unasigned*))
;;     (set! u e1)
;;     (set! v e2)
;;     e3))

;; once we find the first non-definition - we stop.
;; if we run out body - we stop.

(define (scan-out-defines lambda-procedure)
  (define (get-the-defines defines body)
    (if (definition? (car body))
	(get-the-defines (cons (car body) defines) (cdr body))
	(cons defines body)))
  (define (make-let-vars vars)
    (map (lambda (d) (list (definition-variable d) '*unassigned*)) vars))
  (define (make-set-vars vars)
    (map (lambda (d) (list 'set! (definition-variable d) (definition-value d))) vars))
  (define (make-let vars body) (cons 'let (cons vars body)))
  (let ((defines-and-body (get-the-defines '() (lambda-body lambda-procedure))))
    (let ((defines (car defines-and-body))
	  (body (cdr defines-and-body)))
      (make-lambda (lambda-parameters lambda-procedure)
		   (list 
		    (make-let (make-let-vars defines) 
			      (append (make-set-vars defines) body)))))))


;; intstall scan-out-defines in either make-procedure or procedure-body.
;; which is a better place and why?
;; 
;; i think mkae-procedure is better because this is where we have
;; determined we are evaluating a procedure and are storing its
;; defintion into the environment. I think it is better to not have
;; things be modified as they are extracted from the enrivonment. I
;; think it is better to have the accessor be simpler.
