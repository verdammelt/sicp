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

