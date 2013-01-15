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
(define (tan-cf x k)
  (define (n i) (* x x))
  (define (d i)
    (* -1 (- (* 2 i) 1)))
  (* (/ 1.0 x)
     (cont-frac n d k)))

(define pi 3.14159)
(define (to-radians deg) (* deg (/ pi 180.0)))

(newline)
(map (lambda (d)
       (format #t "(tan-cf ~A)=>~A~%" d (tan-cf (to-radians d) 100))
       (format #t "(tan ~A)=>~A~%" d (tan (to-radians d)))
       (newline))
     '(30 45 60 90 180 270 360))

