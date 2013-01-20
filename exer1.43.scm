;; create procedure repeated which takes f and n and returns a
;; lambda which applies f n times
;; e.g. ((repeated square 2) 5) => 625
;; (hint - compose from 1.42 might be useful)

(define (compose f g)
  (lambda (x) (f (g x))))

(define (repeated f n)
  (if (= n 0) (lambda (x) x)
      (compose f (repeated f (- n 1)))))

