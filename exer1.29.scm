(load-option 'format)
;;; simpson's rule
;;; integral of a function is:
;;; (/ h 3)(+ y0 + 4y1 + 2y2 + 4y3 + 2y4...)
;;; where h = (/ (- b a) n)
;;; and yk = f(a+kh)
;;;
;;; implement method which takes f, a, b, n and compare with results
;;; of integral defined in the book.
;;;
(define (cube x)
  (* x x x))

(define inc 1+)

(define (sum term a next b)
  ;; (format #t "(SUM ~A ~A ~A ~A)" term a next b)
  (if (> a b)
      0
      (+ (term a)
	 (sum term (next a) next b))))

(define (integral f a b dx)
  (define (add-dx x) (+ x dx))
  (* (sum f (+ a (/ dx 2.0)) add-dx b)
     dx))

(define (simpson f a b n)
  (define (h) (/ (- b a) n))
  (define (y k) (* (* 2 (expt 2 (remainder k 2)))
		   (f (+ a (* k (h))))))
  (* (+ (y 0) (sum y 1 inc n))
     (/ (h) 3.0)))
