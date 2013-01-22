;; church numerals

(define zero (lambda (f) (lambda (x) x)))
(define (add-1 n) (lambda (f) (lambda (x) (f ((n f) x)))))

;; define one and two directly (without add-1)

(define one (lambda (f) (lambda (x) (f x))))
(define two (lambda (f) (lambda (x) (f (f x)))))

;; define a direct definition of plus (without add-1)
(define (plus x y) (x y))

