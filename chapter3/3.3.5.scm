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




