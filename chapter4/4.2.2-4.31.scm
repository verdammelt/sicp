;; Design and make changes so programmer specify which arguments to a
;; procedure are lazy and if the lazy-ness is memoized or not.
;; ex: (define (f a (b lazy) c (d lazy-memo)) ...)
;;

(define (log-it x) (newline) (display x))
(define (log-force-it obj)
  (cond ((thunk? obj) (log-it (list 'force-it 'thunk (thunk-exp obj))))
	((evaluated-thunk? obj) (log-it (list 'force-it
					      'evaluated-thunk
					      (thunk-value obj))))
	(else (log-it '(force-it 'obj)))))

;; starting from lazy-eval as defined in 4.2
;(load "lazy-eval.scm")

;; First change delay-it and force-it to handle memoized and
;; non-memoized thunks
(define (delay-it exp env memoize?) 
  ;; (log-it (list 'delay-it exp 'ENV memoize?))
  (list 'thunk exp env memoize?))

(define (thunk-memoize? thunk) (cadddr thunk))

(define (force-it obj)
  ;; (log-force-it obj)
  (cond ((and (thunk? obj) (thunk-memoize? obj))
         (let ((result (actual-value
                        (thunk-exp obj)
                        (thunk-env obj))))
           (set-car! obj 'evaluated-thunk)
           (set-car! (cdr obj) result)  ; replace exp with its value
           (set-cdr! (cdr obj) '())     ; forget unneeded env & flag
           result))
	((thunk? obj) (actual-value (thunk-exp obj) (thunk-env obj)))
        ((evaluated-thunk? obj) (thunk-value obj))
        (else obj)))


;; Now we need to change apply so that it only sometimes delays the
;; list of args. It will do this by looking at the list of parameters
;; to see if they are lazy, lazy-memo or neither.

(define (procedure-parameter-names-only procedure)
  (map (lambda (x) (if (pair? x) (car x) x)) (procedure-parameters procedure)))

(define (lazy-memo-parameter? parameter)
  (and (pair? parameter) (eq? (cadr parameter) 'lazy-memo)))
(define (lazy-parameter? parameter)
  (and (pair? parameter) (eq? (cadr parameter) 'lazy)))
(define (non-lazy-parameter? parameter)
  (not (pair? parameter)))

(define (maybe-delay parameter-defintion exp env)
  ;; (log-it (list 'maybe-delay parameter-defintion exp))
  (cond ((lazy-memo-parameter? parameter-defintion) 
	 (delay-it exp env true))
	((lazy-parameter? parameter-defintion) 
	 (delay-it exp env false))
	((non-lazy-parameter? parameter-defintion)
	 (eval exp env))
	(else (error "Unknown parameter defintion"
		     parameter-defintion))))

(define (list-of-maybe-delayed-args parameters args env)
  ;; (log-it (list 'list-of-maybe-delayed-args parameters args))
  (if (no-operands? args)
      '()
      (let ((parameter (car parameters))
	    (arg (first-operand args)))
	(cons (maybe-delay parameter arg env)
	      (list-of-maybe-delayed-args (rest-operands parameters)
					  (rest-operands args)
					  env)))))

(define (apply procedure arguments env)
  (cond ((primitive-procedure? procedure)
         (apply-primitive-procedure
          procedure
          (list-of-arg-values arguments env))) ; changed
        ((compound-procedure? procedure)
         (eval-sequence
          (procedure-body procedure)
          (extend-environment
           (procedure-parameter-names-only procedure)
           (list-of-maybe-delayed-args (procedure-parameters procedure) arguments env)
           (procedure-environment procedure))))
        (else
         (error
          "Unknown procedure type -- APPLY" procedure))))
