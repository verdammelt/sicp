;; church numerals

(define zero (lambda (f) (lambda (x) x)))
(define (add-1 n) (lambda (f) (lambda (x) (f ((n f) x)))))

;; define one and two directly (without add-1)

(define one (lambda (f) (lambda (x) (f x))))
(define two (lambda (f) (lambda (x) (f (f x)))))

(define three (lambda (f) (lambda (x) (f (f (f x))))))

;; define a direct definition of plus (without add-1)
(define (plus n m) 
  (lambda (f) (lambda (x) ((n f) ((m f) x)))))

;; (pred (lambda (f) (lambda (x) (f x))))  --->  (lambda (f) (lambda (x) x))
;; (pred (lambda (f) (lambda (x) (f (f x)))))  --->  (lambda (f) (lambda (x) (f x)))

(define (pred n)
  (lambda (f) (n zero)))

;; x^y
(define (exponent n m)
  (m n))

(define (multiply n m)
  (lambda (f) (n (m f))))


;; (idea from Bill-the-Lizard: use inc as a means to verify)
(define (inc n) (+ n 1))
(define (cn-test cn)
  ((cn inc) 0))

(newline) (display ((zero inc) 0)) ; ==> 0
(newline) (display ((one inc) 0)) ; ==> 1
(newline) (display ((two inc) 0)) ; ==> 2
(newline) (display "expected 0 1 2")
(newline) (display "PLUS")
(newline) (display (((plus zero one) inc) 0)) ; => 1
(newline) (display (((plus one one) inc) 0)) ; => 2
(newline) (display (((plus two one) inc) 0)) ; => 3
(newline) (display (((plus two two) inc) 0)) ; => 4
(newline) (display (((plus two zero) inc) 0)) ; => 2
(newline) (display "expected 1 2 3 4 2")



