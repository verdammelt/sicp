(load "primitive-constraints")

(define (c+ x y)
  (let ((z (make-connector)))
    (adder x y z)
    z))

(define (cv v)
  (let ((c (make-connector)))
    (constant v c)
    c))

(define (c/ x y)
  (let ((z (make-connector)))
    (multiplier z y x)
    z))

(define (c* x y)
  (let ((z (make-connector)))
    (multiplier x y z)
    z))
