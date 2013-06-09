(load-option 'format)

(define (average x y) (/ (+ x y) 2))

;; code from the chapter
;; this is bad for 0.00000000000000000001
;; this is bad for (* 99999999999 999999999)

(define (sqrt x)
  (define (sqrt-iter guess)
    (if (good-enough? guess)
	guess
	(sqrt-iter (improve guess))))
  (define epsilon 0.0001)
  (define (good-enough? guess)
    (< (abs (- (square guess) x)) epsilon))
  (define (improve guess)
    (average guess (/ x guess)))

  (sqrt-iter 1.0))

;; 1.6
(define (sum-squares-biggest-of-three x y z)
  (define (bigger-than x y) (> x y))
  (if (> x y)
      (+ (square x) (square (max y z)))
      (+ (square y) (square (max x z))))
  )

;;1.7
(define (sqrt-v2 x)
  (define (sqrt-iter guess last-guess)
    (format #t "trying ~A~%" guess)
    (if (good-enough? guess last-guess)
	guess
	(sqrt-iter (improve guess) guess)))
  (define epsilon 0.0001)
  (define (good-enough? guess last-guess) (= guess last-guess))
  (define (improve guess) (average guess (/ x guess)))

  (sqrt-iter 1.0 0))

;; 1.8
(define (cubert x)
  (define (cubert-iter guess last-guess)
    (format #t "trying ~A (last: ~A)~%" guess last-guess)
    (if (good-enough? guess last-guess) 
	guess 
	(cubert-iter (improve guess) guess)))
  (define epsilon 0.000001)
  (define (good-enough? guess last-guess) 
    (= guess last-guess))
  (define (improve guess) 
    ;; ((x/y^2)+2y)/3)
    (/ (+ (/ x 
	     (square guess)) 
	  (* 2 guess)) 
       3))

  (cubert-iter 1.0 0.0))

;; 1.9
(define (plus a b)
  (if (= a 0)
      b
      (inc (plus (dec a) b))))
;; substitution for (plus 4 5)
;; (plus 4 5)
;; (inc (plus 3 5)
;; (inc (inc (plus 2 5)))
;; (inc (inc (inc (plus 1 5))))
;; (inc (inc (inc (inc (plus 0 5)))))
;; (inc (inc (inc (inc 5))))
;; (inc (inc (inc 6)))
;; (inc (inc 7))
;; (inc 8)
;; 9
;; linear recursive process

(define (plus a b)
  (if (= a 0)
      b
      (plus (dec a) (inc b))))
;; substitution for (plus 4 5)
;; (plus 3 6)
;; (plus 2 7)
;; (plus 1 8)
;; (plus 0 9)
;; 9
;; linear iterative process (also tail recursive)

;; 1.10
(define (A x y)
;  (format #t "(A ~A ~A)~%" x y)
  (cond ((= y 0) 0)
	((= x 0) (* 2 y))
	((= y 1) 2)
	(else (A (- x 1)
		 (A x (- y 1))))))

;; (format #t "~A~%" (A 1 10))
;; (format #t "~A~%" (A 2 4))
;; (format #t "~A~%" (A 3 3))

(define (f n) (A 0 n))
(define (g n) (A 1 n))
(define (h n) (A 2 n))

;; f(n) => n = 0 -> 0
;;         n     -> 2n
;; g(n) => n = 0 -> 0
;;               -> 2**n
;; h(n) => n = 0 -> 0
;;         n     -> 2**(2**n)

;; making change
(define (count-change amount)
  (cc amount 6))
(define (cc amount kinds-of-coins)
  (cond ((= amount 0) 1)
	((or (< amount 0) (= kinds-of-coins 0)) 0)
	(else (+ (cc amount
		     (- kinds-of-coins 1))
		 (cc (- amount 
			(first-denomination kinds-of-coins))
		     kinds-of-coins)))))
(define (first-denomination kinds-of-coins)
  (cond ((= kinds-of-coins 1) 1)
	((= kinds-of-coins 2) 5)
	((= kinds-of-coins 3) 10)
	((= kinds-of-coins 4) 25)
	((= kinds-of-coins 5) 50)
	((= kinds-of-coins 6) 100)))

;;  1.11
;; f(n) = n if n < 3; 
;; f(n) = f(n-1)+2f(n-2)+3f(n-3) n >= 3
;; write recursive process
(define (f-recur n)
  (if (< n 3) n
      (+ (f-recur (- n 1))
	 (* 2 (f-recur (- n 2)))
	 (* 3 (f-recur (- n 3))))))

;(format #t "f(6) = ~A~%" (f-recur 6))

;; write iterative process
(define (f-iter n)
  (define (inner a b c count)
    (if (= count 0)
	c
	(inner (+ a (* 2 b) (* 3 c)) a b (- count 1))))
  (inner 2 1 0 n))

;(format #t "f(6) = ~A~%" (f-iter 6))

;; 1.12
;; write method to compute the elements of a pascal's triangle
(define (pascal row col)
;  (format #t "(pascal ~A ~A)~%" row col)
  (cond ((or (= col 0) (= col row)) 1)
	(else (+ (pascal (- row 1) (- col 1))
		 (pascal (- row 1) col))
	 )))

;(format #t "(pascal 4 2) = ~A   (should be 6)~%" (pascal 4 2))


;; 1.13
;; The claim is that fib(n) closest int to phi^n/(sqrt 5) 
;; where phi = (1 + (sqrt 5))/2
;; hint: psi = (1-(sqrt 5))/2
;; fib(n) = (phi^n - psi^n)/(sqrt 5)
(define (fib n)
  (if (< n 2) n 
      (+ (fib (- n 1)) 
	 (fib (- n 2)))))

(define (check n)
  (define sqrt5 (sqrt 5))
  (define phi (/ (+ 1 sqrt5) 2))
  (define psi (/ (- 1 sqrt5) 2))
  (define fib-num (fib n))
  (define aprox (/ (- (expt phi n) (expt psi n)) 
		   sqrt5))
  (format #t "(fib n) => ~A ~~ ~A~%" fib-num aprox))

;; copped out from actually proving this by induction.


;; 1.15
(define (sine angle)
  (define (cube x) (* x x x))
  (define (p x)
    (format #t "p called~%")
    (- (* 3 x) (* 4 (cube x))))
  (if (not (> (abs angle) 0.1))
      angle
      (p (sine (/ angle 3.0)))))
;; the order of growth in time and size for (sine a)
;; I say: time = O(a) size = O(a)
;; Bill the Lizard says O(logn) because it goes up less than linear
;; becuase it only increases every multiple of 3

;; section 1.2.4
;; define mult so we can count the number of multiplications
(define (mult x y)
  (format #t "(mult ~A ~A)~%" x y)
  (* x y))
(define (expt-recur b n)
  (if (= n 0)
      1
      (mult b (expt-recur b (- n 1)))))
(define (expt b n)
  (define (expt-iter counter product)
    (if (= counter 0)
	product
	(expt-iter (- counter 1)
		   (mult b product))))
  (expt-iter n 1))
(define (fast-expt b n)
  (define (even? n) (= (remainder n 2) 0))
  (define (square x) (mult x x))
  ;; (format #t "(fast-expt ~A ~A)~%" b n)
  (cond ((= n 0) 1)
	((even? n) (square (fast-expt b (/ n 2))))
	(else (mult b (fast-expt b (- n 1))))))

;; 1.16
(define (faster-expt b n)
  (define (even? n) (= (remainder n 2) 0))
  (define (square x) (mult x x))
  (define (inner b n a)
    ;; keep a(b^n) constant
    ;; note that (b^(n/2))^2 = (b^2)^(n/2) 
    (format #t "(faster-expt-inner ~A ~A ~A)~%" b n a)
    (cond ((= n 0) a)
	  ((even? n) (inner (square b) (/ n 2) a))
	  (else (inner b (- n 1) (mult b a))))
    )
  (inner b n 1)
)

;; 1.17
;; defined so we can see the additions
(define (add x y) (format #t "(add ~A ~A)~%" x y) (+ x y))
(define (dumb-mult a b)
  (if (= b 0) 0
      (add a (dumb-mult a (- b 1)))))

;; miraculously we have the following two functions built into our
;; language (the one without the * function)
(define (halve n) (/ n 2))
(define (double n) (add n n))

;; now we can define a less-dumb-mult which has log growth rate
(define (less-dumb-mult a b)
  (cond ((= b 0) 0)
	((even? b) (double (less-dumb-mult a (halve b))))
	(else (add a (less-dumb-mult a (- b 1))))))

;; 1.18
;; iterative instead of recursive as above - same number of adds
(define (not-bad-mult a b)
  (define (inner a b acc)
    (cond ((= b 0) acc)
	  ((even? b) (inner (double a) (halve b) acc))
	  (else (inner a (- b 1) (add a acc)))))
  (inner a b 0))

;; 1.19
;; fib(n) = T^n
;; T = T(p,q)
;; T(0, 1) = a<-bq+aq+ap b<-bp+aq
;; See Journal - pages 63-66 for scribblings related to this.
;; ultimately i failed to get this and bill the lizard set me straight. 
(define (fib n)
  (fib-iter 1 0 0 1 n))
(define (fib-iter a b p q count)
  (cond ((= count 0) b)
	((even? count)
	 (fib-iter a
		   b
		   (+ (square p) (square q))
		   (+ (* 2 p q) (square q))
		   (/ count 2)))
	(else (fib-iter (+ (* b q) (* a q) (* a p))
			(+ (* b p) (* a q))
			p
			q
			(- count 1)))))

(define (check-fib n)
  (define (old-fib n)
    (if (< n 2) n 
	(+ (old-fib (- n 1)) 
	   (old-fib (- n 2)))))
  (format #t "new-fib = ~A~%old-fib = ~A~%" (fib n) (old-fib n)))

;; 1.20
(define (gcd a b)
  (define (rem a b) (format #t "(rem ~A ~A)~%" a b) (remainder a b))
  (if (= b 0) a
      (gcd b (rem a b))))
;; for (gcd 206 40)
;; applicative order calls rem N times
;; normative order calls rem N+1 times (WRONG)
;; normaitive means fully expand before reducing!
(gcd 206 40)=>
(if (= 40 0) 206
    (gcd 40 (rem 206 40)))
(if (= 40 0) 206
    (if (= (rem 206 40) 0) 40
	(gcd 40 (rem 40 (rem 206 40)))))


