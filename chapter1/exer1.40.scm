(load-option 'format)

;; further back in the book
(define (average x y)
  (/ (+ x y) 2))
(define (fixed-point f first-guess)
  (define tolerance 0.00001)
  (define (close-enough? v1 v2)
    (< (abs (- v1 v2)) tolerance))
  (define (try guess)
    (newline) (display guess)
    (let ((next (f guess)))
      (if (close-enough? guess next)
	  next
	  (try next))))
  (try first-guess))

;; from section 1.3.4
(define (average-damp f)
  (lambda (x) (average x (f x))))

;; (define (sqrt x)
;;   (fixed-point (average-damp (lambda (y) (/ x y)))
;; 	       1.0))

;; (define (cube-root x)
;;   (fixed-point (average-damp (lambda (y) (/ x (square y))))
;; 	       1.0))

(define (deriv g)
  (define dx 0.00001)
  (lambda (x)
    (/ (- (g (+ x dx)) (g x))
       dx)))

(define (cube x) (* x x x))

(define (newton-transform g)
  (lambda (x)
    (- x (/ (g x) ((deriv g) x)))))

(define (newtons-method g guess)
  (fixed-point (newton-transform g) guess))

;; (define (sqrt x)
;;   (newtons-method (lambda (y) (- (square y) x))
;; 		  1.0))

(define (fixed-point-transform g transform guess)
  (fixed-point (transform g) guess))

;; (define (sqrt x)
;;   (fixed-point-transform (lambda (y) (/ x y))
;; 			 average-damp
;; 			 1.0))

;; (define (sqrt x)
;;   (fixed-point-transform (lambda (y) (- (square y) x))
;; 			 newton-transform
;; 			 1.0))


;;; define procedure cubic that can be used with newtons-method like:
;;; (newtons-method (cubic a b c) 1)
;;; to approximate the zeros of x^3 + ax^2 + bx + c
(define (cubic a b c)
  (lambda (x) (+ (cube x)
		 (* a (square x))
		 (* b x)
		 c)))

(define (roots-for-cubic a b c)
  (newtons-method (cubic a b c) 1))

(define (nearly-zero x)
  (< (abs x) 0.000001))

(newline)
(display (nearly-zero ((cubic 1 2 3) (roots-for-cubic 1 2 3))))
(newline)
(display (nearly-zero ((cubic 3 4 5) (roots-for-cubic 3 4 5))))




