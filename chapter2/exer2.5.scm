;; show we can represent pairs of non-negative integers (a,b) as a
;; single integer (*2^a 3^b)
;; define cons, car and cdr
;; (note: nni -> non-negative-integer
(define (nni-cons a b)
;  (newline) (display "(nni-cons ") (display a) (display " ") (display b) (display ")")
  (* (expt 2 a) (expt 3 b)))
(define (nni-car p)
  (let ((2part (/ p (expt 3 (nni-cdr p)))))
    (log-n-of-x 2 2part)))
(define (nni-cdr p)
  (define (find-b max)
    (cond ((= max 0) max)
	  ((= (remainder p (expt 3 max)) 0) max)
	  (else (find-b (- max 1)))))
  (find-b (log-n-of-x 3 p)))

(define (log-n-of-x n x)
  (round (/ (log x) (log n))))

(define (nni-print p)
  (newline)
  (display "[")
  (display p)
  (display ";(")
  (display (nni-car p))
  (display " . ")
  (display (nni-cdr p))
  (display ")]"))

(nni-print (nni-cons 2 3))
(nni-print (nni-cons 13 23))


;; more concise definitions - from a comment on Bill-the-Lizard's site.
(define (nni-car p)
  (log-n-of-x 2 (/ p (gcd p (expt 3 (log-n-of-x 3 p))))))
(define (nni-cdr p) 
  (log-n-of-x 3 (/ p (gcd p (expt 2 (log-n-of-x 2 p))))))

