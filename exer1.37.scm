;; 1.37a
;; create a function for computing continued fractions:
;; f = N1/(D1+N2/(D2+N3/(D3+N4/D5....
;; it can be approximated by only going out k steps
;; make a function (cont-frac n d k) that computes a continued
;; fraction to k steps.
;; use it to compute 1/phi by using Ni = 1 and Di = 1 for all values
;; of i
(newline)
(format #t "NOTE: 1/phi ~~ 0.61803398875~%")

(define (cont-frac n d k) 
  (define (calculate n d k i)
    (if (> i k) 1
	(/ (n i) (+ (d i) 
		    (calculate n d k (1+ i))))))
  (calculate n d k 1)
  )

(newline)
(display 'recursive)
(display
 (map (lambda (k) (cons k (cont-frac (lambda (i) 1.0)
				     (lambda (i) 1.0)
				     k)))
      '(1 2 5 10 100 1000 10000)))

;; needed 100 to get accuracy to 4 decimal places


;; 1.37b - now make it linear iterative or visa-versa


(define (cont-frac-iter n d k) 
  (define (calculate n d i result)
    (if (= i 0) result
	(calculate n d (- i 1)
		   (/ (n i) (+ (d i) result))))
    )
  (calculate n d (- k 1) (/ (n k) (d k)))
  )

(newline)
(display 'iterative)
(display
 (map (lambda (k) (cons k (cont-frac-iter (lambda (i) 1.0)
					  (lambda (i) 1.0)
					  k)))
      '(1 2 5 10 100 1000 10000)))

