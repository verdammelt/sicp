(load "sequences.scm")

;; from the book text
(define (prime-sum? pair)
  (prime? (+ (car pair) (cadr pair))))

(define (make-pair-sum pair)
  (list (car pair) (cadr pair) (+ (car pair) (cadr pair))))

(define (prime-sum-pairs n)
  (map make-pair-sum
       (filter prime-sum?
	       (flatmap
		(lambda (i)
		  (map (lambda (j) (list i j))
		       (enumerate-interval 1 (- i 1))))
		(enumerate-interval 1 n)))))

;; a 'reasonable' prime?
(define (prime? n)
  (define (divides? a b)
    (= (remainder b a) 0))
  (define (find-divisor n test-divisor)
    (cond ((> (square test-divisor) n) n)
	  ((divides? test-divisor n) test-divisor)
	  (else (find-divisor n (1+ test-divisor)))))
  (define (smallest-divisor n)
    (find-divisor n 2))

  (= n (smallest-divisor n)))

;; define unique-pair that given an integer n generates a sequence of
;; pairs (i,j) with 1<=j<i<=n.
(define (unique-pairs n)
  (flatmap (lambda (i)
	     (map (lambda (j) (list i j))
		  (enumerate-interval 1 (- i 1))))
	   (enumerate-interval 1 n)))

;; then use unique-pairs to simplify definition of prime-sum-pairs
(define (my-prime-sum-pairs n)
  (map make-pair-sum (filter prime-sum? (unique-pairs n))))
