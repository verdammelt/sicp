(load "sequences.scm")

;; define a function that finds all ordered triplets of positive
;; integers i, j, k less than or equal to a given integer n that sum
;; to a given integer s
(define (triplets-that-sum n s)
  (filter (lambda (triplet)
	    (= s (+ (car triplet)
		    (cadr triplet)
		    (caddr triplet))))
	  (flatmap 
	   (lambda (i)
	     (flatmap (lambda (j)
			(map (lambda (k) (list i j k))
			     (enumerate-interval 1 (- j 1))))
		      (enumerate-interval 1 (- i 1))))
	   (enumerate-interval 1 n))))
