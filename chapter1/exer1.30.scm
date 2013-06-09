;;; sum procedure (included in chapter) is linear recursive. Change to be linear iterative
;;;
(define (cube x)
  (* x x x))

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

(define (sum-iter term a next b)
  (define (iter a result)
    (if (> a b)
	result
	(iter (next a) (+ (term a) result))))
  (iter a 0))

(define (integral-iter f a b dx)
  (define (add-dx x) (+ x dx))
  (* (sum-iter f (+ a (/ dx 2.0)) add-dx b)
     dx))


(newline)
(format #t "integral with dx = 0.01 => ~A~%" (integral cube 0 1 0.01))
(format #t "integral-iter with dx = 0.01 => ~A~%" (integral-iter cube 0 1 0.01))
(format #t "integral with dx = 0.001 => ~A~%" (integral cube 0 1 0.001))
(format #t "integral-iter with dx = 0.001 => ~A~%" (integral-iter cube 0 1 0.001))
