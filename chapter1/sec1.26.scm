(load-option 'format)

(define (smallest-divisor n)
  (find-divisor n 2))

(define (find-divisor n test-divisor)
  (cond ((> (square test-divisor) n) n)
	((divides? test-divisor n) test-divisor)
	(else (find-divisor n (+ test-divisor 1)))))

(define (divides? a b)
  (= (remainder b a) 0))

(define (prime? n)
  (= n (smallest-divisor n)))

(define (expmod base exp m)
  (cond ((= exp 0) 1)
	((even? exp)
	 (remainder (square (expmod base (/ exp 2) m))
		    m))
	(else
	 (remainder (* base (expmod base (- exp 1) m))
		    m))))

(define (fermat-test n)
  (define (try-it a)
    (= (expmod a n n) a))
  (try-it (+ 1 (random (- n 1)))))

(define (fast-prime? n times)
  (cond ((= times 0) true)
	((fermat-test n) (fast-prime? n (- times 1)))
	(else false)))

;; 1.21
;; (smallest-divisor 199) => 199
;; (smallest-divisor 1999) => 1999
;; (smallest-divisor 19999) => 7

;; 1.22
(define (timed-prime-test-flex fn n)
  ;; (newline)
  ;; (display n)
  (start-prime-test fn n (real-time-clock)))
(define (timed-prime-test n)
  (timed-prime-test-flex prime? n))
(define (start-prime-test fn n start-time)
  (cond ((fn n)
	 (newline) (display n)
	 (report-prime (- (real-time-clock) start-time))
	 )))
(define (report-prime elapsed-time)
  (display " *** ")
  (display elapsed-time))

(define (search-for-primes-flex fn low hi)
  (cond ((even? low) (search-for-primes-flex fn (+ 1 low) hi))
	((< low hi) 
	 (fn low)
	 (search-for-primes-flex fn (+ 2 low) hi))))

(define (search-for-primes low hi)
  (search-for-primes-flex timed-prime-test low hi))

;; search-for-primes starting at 10^10 (lower numbers too fast...)
;; 10^10 - [136,135,135] - avg 135.333
;; 10^11 - [433,426,427] - avg 428.666
;; 10^12 - [1348,1359,1342] - avg 1349.666
;; 10^13 - [4279,4330,4283] - avg 4297.333
;; the ratio between the values are: 3.167, 3.149, 3.184
;; (sqrt 10) => 3.16 - so the ratio is approx (sqrt 10)

;; the primes found were
(define primes-from-1.22
  '(10000000019 10000000033 10000000061
		100000000003 100000000019 100000000057 
		1000000000039 1000000000061 1000000000063
		10000000000037 10000000000051 10000000000099
		))

;; 1.23 - speeding up find-divisor
(define old-find-divisor find-divisor) ;; so i can swap back and forth

(define (find-divisor n test-divisor)
  (define (next d)
    (if (= d 2) 3 (+ 2 d)))
  (cond ((> (square test-divisor) n) n)
	((divides? test-divisor n) test-divisor)
	(else (find-divisor n (next test-divisor)))))

(define new-find-divisor find-divisor) ;; so i can swap back and forth

;; the resulting speed up was only about 1.5-1.75 - never the x2 speed
;; up we'd expect from doing half the divisions.  i think that the
;; reason for that is that a primitie + operation was replaced with an
;; if and =

;; 1.24
;; do timed testing with fast-prime?
(define (timed-fast-prime-test n)
  (timed-prime-test-flex (lambda (n) (fast-prime? n 100)) n))
;; (map timed-fast-prime-test primes-from-1.22)

;; this was VERY fast - increased 10 -> 100 and still got numbers MUCH
;; smaller (10 vs. 4000). Also the numbers were largely FLAT - not
;; much variation as N grew larger.  I'd say it was because we are
;; doing X number of checks (10, 100 etc) for every N - not a number
;; of checks which varies with N

;; Looking at Bill the Lizard's response it seems like perhaps the
;; exercise was to run search-for-primes again to get the numbers
;; again.
(define (search-for-fast-primes low hi)
  (search-for-primes-flex timed-fast-prime-test low hi))
;; the numbers were STILL HUGELY FASTER. and largely constant as N increased.
;; there was some uptick in time as N increased but not much.

;; 1.25 
;; what happens if we replace expmod with the below?
;; (define (expmod base exp m)
;;    (remainder (fast-expt base exp) m))
;; (define (fast-expt b n)
;; (cond ((= n 0) 1)
;; 	((even? n) (square (fast-expt b (/ n 2))))
;; 	(else (* b (fast-expt b (- n 1))))))
;; it appears to SLOW it way down. 
;; expmod with fast-expt varies with B^N and as it gets bigger than M 
;; the calculation of the remainder must get worse.

;; 1.26
;; the reason that it gets so much worse is that
;; (square x) evaluates x once
;; (* x x) evaluates x twice
;; and here x is a recursive call to expmod.

;; 1.27
;; carmichael numbers are integers which can fool the fermat-test
;; algorithm.

(define carmichael-numbers '(561 1105 1729 2465 6601))
;; write a function which shows that for an integer N that a^n is
;; congruent to a mod n for every a < n
(define (test-carmichael n)
  (define (test a n)
    (cond ((= a n) 'OMG-PRIME)
	  ((= (expmod a n n) a) (test (+ a 1) n))
	  (else 'LOL-NOT-PRIME)))
  (test 2 n))

;; 1.28
;; Miller-Rabin prime test
;; involves A(N-1) congruent to 1 modulo N
;; also involves checking for 'trivial square root of 1 modulo n'
;; very confusing terminology - finally got my head around it
;; (with much help of web sites)
;;
(define (miller-rabin n times)
  (define (mr-expmod base exp)
    (define (zero-if-non-trivial-square-root a)
      (if (and (not (= a 1)) 
	       (not (= a (- n 1)))
	       (= (remainder (square a) n) 1)) 
	  0 
	  a))
    
    (cond ((= exp 0) 1)
	  ((even? exp)
	   (remainder (square (zero-if-non-trivial-square-root
			       (mr-expmod base (/ exp 2)))) n))
	  (else
	   (remainder (* base (mr-expmod base (- exp 1))) n))))
  
  (define (try-it a)
    (= (mr-expmod a (- n 1)) 1))
  
  (cond ((= times 0) true)
	((try-it (+ 1 (random (- n 1)))) (miller-rabin n (- times 1)))
	(else false)))

(newline)
(format #t "ALL FALSE -> ~A~%" (map (lambda (n) (miller-rabin n 100))
				  carmichael-numbers))
(format #t "ALL TRUE  -> ~A~%" (map (lambda (n) (miller-rabin n 100))
				    primes-from-1.22))
(newline)


