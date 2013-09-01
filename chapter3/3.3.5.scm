(load "constraint-propagation")
(load "primitive-constraints")

;; exercise 3.33
;; using the adder, multiplier and constant constraints define an
;; averager procedure. It takes three connectors: a, b, c and
;; establishes the constraint that c is the average of a and b
(define (averager a b c)
  (let ((sum (make-connector))
	(half (make-connector)))
    (adder a b sum)
    (multiplier sum half c)
    (constant 0.5 half)
    'ok))

;; exercise 3.34

;; Louis Reasoner wants to build a squarer constraint
;; he defines it like:
(define (squarer a b)
  (muliplier a a b))
;; it has a serious flaw. Explain.
;; mjs: it can only work in one direction. Setting a will cause b 
;; to be computed - but it cannot compute the value for a based upon
;; b as multiplier needs two of its three connectors to have values to 
;; compute the third.

;; exercise 3.35
;; Ben Bitdiddle tells Louis that squarer needs to be a primitive 
;; constraint. Finish the implementation:
(define (squarer a b)
  (define (process-new-value)
    (if (has-value? b)
	(if (< (get-value b) 0)
	    (error "square less than 0 -- SQUARER" (get-value b))
	    ;; alternative 1
	    (set-value! a 
			(sqrt (get-value b))
			me))
	;; alternative 2
	(set-value! b 
		    (square (get-value a))
		    me)))
  (define (process-forget-value)
    ;; body 1
    (forget-value! a me)
    (forget-value! b me)
    (process-new-value))
  (define (me request)
    ;; body 2
    (cond ((eq? request 'I-have-a-value)
	   (process-new-value))
	  ((eq? request 'I-lost-my-value)
	   (process-forget-value))
	  (else
	   (error "Unknown request -- SQUARER" request))))
  ;; rest of definition
  (connect a me)
  (connect b me)
  me)


;; exercise 3.36 (skipping - i hate environment diagrams)
