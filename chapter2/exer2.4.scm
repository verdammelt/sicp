;; given this definition of cons
(define (cons x y)
  (lambda (m) (m x y)))
(define (car z)
  (z (lambda (p q) p)))

;; define cdr
(define (cdr z)
  (z (lambda (p q) q)))

(define a (cons 1 2))
(define b (car a))
(define c (cdr a))
(newline)
(display "cons=")
(display a)
(newline)
(display "car=")
(display b)
(newline)
(display "cdr=")
(display c)

