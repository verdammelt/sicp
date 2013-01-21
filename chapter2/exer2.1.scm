(load "chapter2/rational.scm")

;; define a better version of make-rat which handles positive &
;; negative rational numbers. Normalize the sign so that if the
;; rational number is positive both numerator & denominator is
;; positive, if it is negative only the numerator is negative.
(define (make-rat n d)
  (let ((g (gcd n d))
	(abs-n (abs n))
	(abs-d (abs d)))
    (cond ((or (and (= n abs-n) (= d abs-d))
	       (and (not (= n abs-n)) (not (= d abs-d))))
	   (cons (/ abs-n g) (/ abs-d g)))
	  (else
	   (cons (* -1 (/ abs-n g)) (/ abs-d g))))))

