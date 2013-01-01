(load-option 'format)

(define (average x y) (/ (+ x y) 2))

;; code from the chapter
;; this is bad for 0.00000000000000000001
;; this is bad for (* 99999999999 999999999)

(define (sqrt x)
  (define (sqrt-iter guess)
    (format #t "trying ~A ~A~%" guess)
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
  (format #t "(A ~A ~A)~%" x y)
  (cond ((= y 0) 0)
	((= x 0) (* 2 y))
	((= y 1) 2)
	(else (A (- x 1)
		 (A x (- y 1))))))

(format #t "~A~%" (A 1 10))
(format #t "~A~%" (A 2 4))
(format #t "~A~%" (A 3 3))

(define (f n) (A 0 n))
(define (g n) (A 1 n))
(define (h n) (A 2 n))

;; f(n) => n = 0 -> 0
;;         n     -> 2n
;; g(n) => n = 0 -> 0
;;               -> 2**n
;; h(n) => n = 0 -> 0
;;         n     -> 2**(2**n)




