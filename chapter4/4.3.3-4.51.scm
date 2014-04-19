;; write 'permanent-set!' such that the change is not rolled back by amb:
;; what would the results be if permanent-set! was replaced with set!?

;; Code for the amb interpreter
;; (define (require p)
;;  (if (not p) (amb)))
;; (define (an-element-of items)
;;   (require (not (null? items)))
;;   (amb (car items) (an-element-of (cdr items))))
;; (define count 0)
;; (define (perm-set-test)
;;   (let ((x (an-element-of '(a b c)))
;; 	(y (an-element-of '(a b c))))
;;     (permanent-set! count (+ count 1))
;;     (require (not (eq? x y)))
;;     (list x y count)))

;; (define (set-test)
;;   (let ((x (an-element-of '(a b c)))
;; 	(y (an-element-of '(a b c))))
;;     (set! count (+ count 1))
;;     (require (not (eq? x y)))
;;     (list x y count)))


(define (assignment? exp)
  (or (tagged-list? exp 'set!)
      (tagged-list? exp 'permanent-set!)))

(define (analyze-assignment exp)
  (let ((var (assignment-variable exp))
        (vproc (analyze (assignment-value exp)))
	(permanent? (tagged-list? exp 'permanent-set!)))
    (lambda (env succeed fail)
      (vproc env
             (lambda (val fail2)        ; *1*
               (let ((old-value
                      (lookup-variable-value var env))) 
                 (set-variable-value! var val env)
                 (succeed 'ok
                          (lambda ()    ; *2*
			    (if (not permanent?)
				(set-variable-value! var
						     old-value
						     env))
			    (fail2)))))
             fail))))


;; also note that with permanent-set! the example will show results
;; which 'skip' some values of count (it will go up to two). That is
;; because the permanent set is done before the require check.
