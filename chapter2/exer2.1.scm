(load "chapter2/rational.scm")

;; define a better version of make-rat which handles positive &
;; negative rational numbers. Normalize the sign so that if the
;; rational number is positive both numerator & denominator is
;; positive, if it is negative only the numerator is negative.
(define (make-rat n d)
  (let ((g (gcd n d))
	(abs-n (abs n))
	(abs-d (abs d)))
    (if (< d 0)
	(cons (/ (* n -1) g) (/ (* d -1) g))
	(cons (/ n g) (/ d g)))))

