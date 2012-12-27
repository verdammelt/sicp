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
