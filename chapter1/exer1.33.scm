(load-option 'format)
(define (square x) (* x x))

(define (gcd a b)
  (if (= b 0) 
      a
      (gcd b (remainder a b))))

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

;;; write an even more generic version of accumlate (1.32) using a
;;; concept of a filter procedure argument:
;;; (filter-accumulate filter combiner null-value term a next b)
;;;
;;; a. use it to write method which sums the squares of prime numbers
;;; from a to b
(define (filter-accumulate filter combiner null-value term a next b)
  (cond ((> a b) null-value)
	((filter a)
	 (combiner (filter-accumulate filter combiner null-value term
				      (next a) next b)
		   (term a)))
	(else
	 (filter-accumulate filter combiner null-value term (next a)
			    next b))))

(define (sum-of-square-primes a b)
  (filter-accumulate prime? + 0 square a 1+ b))

(newline)
(format #t "sum of square primes 1-20 => ~A (should be 1028)~%" (sum-of-square-primes 1 20))

;;; b. the product of all positive integers less than n which are
;;; relatively prime to n 
;;; (all pos. integers i < n such that GCD(i, n) = 1)
(define (product-of-relatively-prime-less-than n)
  (define (identity x) x)
  (define (relatively-prime? i)
    (= (gcd i n) 1))
  (filter-accumulate relatively-prime? * 1 identity 1 1+ (- n 1)))

(newline)
(format #t "product of 'relatively prime' numbers less than n (n = 20) => ~A (should be 8729721)~%" 
	(product-of-relatively-prime-less-than 20))

