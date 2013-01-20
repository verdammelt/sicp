;;; smoothing function
;;;
;;; if f is a function and dx is a small number then the smoothed
;;; version of f is the function:
;;; (average (f (- x dx)) (f x) (f (+ x dx)))
;;;
;;; it is often useful to get the nth repeated smoothing of a function
;;; so the previous exercises repeated function could be used.

(define (compose f g)
  (lambda (x) (f (g x))))

(define (repeated f n)
  (if (= n 1)
      f
      (lambda (x) (compose f 
			   (repeated f (- n 1))))))

(define (smooth f)
  (define dx 0.00001)
  (lambda (x) (/ (+ (f (- x dx))
		    (f x)
		    (f (+ x dx)))
		 3)))

(define (very-smooth f n)
  (repeated (smooth f) n))


