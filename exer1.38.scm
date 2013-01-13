;; from exercise 1.37
(define (cont-frac n d k) 
  (define (calculate n d k i)
    (if (> i k) 1
	(/ (n i) (+ (d i) 
		    (calculate n d k (1+ i))))))
  (calculate n d k 1)
  )

;; exer 1.38
;; Euler found a N & D such that the continued fraction computes e-2
;;
;; Ni = 1
;; Di = (1, 2, 1, 1, 4, 1, 1, 6, 1, 1, 8...)
;; using cont-frac find an approximation for e
(define (approx-e k)
  (define (n i) 1.0)
  (define (d i) 
    (if (not (= 0 (remainder (+ 1 i) 3))) 
	1
	(* 2 (/ (+ i 1) 3))))
  (+ 2 (cont-frac n d k)))

(newline)
(display 'e~)
(display 2.71828)
(newline)
(display 
 (map (lambda (k) (cons k (approx-e k)))
      '(1 2 5 10 100 1000 10000)))

