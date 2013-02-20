(load "sequences.scm")

;; define a function that finds all ordered triplets of positive
;; integers i, j, k less than or equal to a given integer n that sum
;; to a given integer s
(define (triplets-that-sum n s)
  (define (triplet-sums-to-s? triplet)
    (= s (+ (car triplet) (cadr triplet) (caddr triplet))))

  (define (unique-pairs n)
    (flatmap (lambda (i)
	       (map (lambda (j) (list i j))
		    (enumerate-interval 1 (- i 1))))
	     (enumerate-interval 1 n)))

  (define (unique-triplets n)
    (flatmap (lambda (i) 
	       (flatmap (lambda (j)
			  (map (lambda (k) (list i j k))
			       (enumerate-interval 1 (- j 1))))
			      (enumerate-interval 1 (- i 1))))
	     (enumerate-interval 1 n)))

  (filter triplet-sums-to-s? (unique-triplets n)))
