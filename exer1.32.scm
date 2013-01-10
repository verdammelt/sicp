(load-option 'format)
;;; sum and product (previous exercises) are specific cases of more
;;; general accumlate function:
;;; (accumlate combiner null-value term a next b)
;;; 

;;; a. define accumlate
(define (accumlate combiner null-value term a next b)
  (if (> a b)
      null-value
      (combiner (accumlate combiner null-value term (next a) next b)
		(term a))))

(define (sum term a next b)
  (accumlate + 0 term a next b))

(define (product term a next b)
  (accumlate * 1 term a next b))

(define (integral f a b dx)
  (define (add-dx x) (+ x dx))
  (* (sum f (+ a (/ dx 2.0)) add-dx b)
     dx))

(define (pi-approx n)
  (define inc 1+)
  (define (term k) 
    (define (b k) (cond ((even? k) (* 2 (/ k 2)))
			(else (* 2 (/ (- k 1) 2)))))
    (define x (+ 2 (b (inc k))))
    (define y (+ 3 (b k)))
    (/ x y))
  (* 4.0 (product term 0 inc n)))

(display 'accumlate-recursive)
(newline)
(format #t "integral of cube with dx = 0.01 (approches .25) => ~A~%" (integral cube 0 1 0.01))
(format #t "(pi-approx 10000) => ~A~%" (pi-approx 10000))


;;; b. define accumlate as linear iterative if previous was recursive
;;; or visa-versa
(define (accumlate combiner null-value term a next b)
  (define (iter a result)
    (if (> a b) result
	(iter (next a)
	      (combiner (term a) result))))
  (iter a null-value))


(display 'accumlate-iter)
(newline)
(format #t "integral of cube with dx = 0.01 (approches .25) => ~A~%" (integral cube 0 1 0.01))
(format #t "(pi-approx 10000) => ~A~%" (pi-approx 10000))

