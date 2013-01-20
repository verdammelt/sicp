(define (compose f g)
  (lambda (x) (f (g x))))

(define (square x) (* x x))
(define (inc x) (1+ x))

((compose square inc) 6) ; => 49


