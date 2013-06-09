(load-option 'format)

;; from exercise 1.37
(define (cont-frac n d k) 
  (define (calculate n d k i)
    (if (> i k) 1
	(/ (n i) (+ (d i) 
		    (calculate n d k (1+ i))))))
  (calculate n d k 1)
  )


;; (tan x) can be defined as a continued-frac of the form:
;; tan x = x / (1 - (x^2 / (3 - x^2 / 5 - (x^2...
;; (where x is in radians)
;; using cont-frac define (tan-cf x k) (k = number of terns to compute)
;; 
;; mjs: so n(i) = (* x x)
;; mjs: d(i) = -1, -3, -5, -7... (e.g. -1(2n-1))
(define (tan-cf x k)
  (define (n i) (if (= i 1) x (* -1.0 x x)))
  (define (d i) (- (* 2 i) 1))
  (cont-frac n d k))

(define pi 3.14159)

(newline)
(map (lambda (d)
       (let ((rad (/ (* d pi) 4))) 
	 (format #t "(tan-cf ~Api)=>~A~%" (/ d 4) (tan-cf rad 1000))
	 (format #t "(tan ~Api)=>~A~%" (/ d 4) (tan rad)))
       (newline))
     '(0 1 2 3 4))

