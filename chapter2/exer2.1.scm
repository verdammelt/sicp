(define (make-rat n d) 
  (let ((g (gcd n d)))
    (cons (/ n g) (/ d g))))
(define (numer x) (car x))
(define (denom x) (cdr x))

(define (add-rat x y)
  (make-rat (+ (* (numer x) (denom y))
	       (* (numer y) (denom x)))
	    (* (denom x) (denom y))))

(define (sub-rat x y)
  (make-rat (- (* (numer x) (denom y))
	       (* (numer y) (denom x)))
	    (* (denom x) (denom y))))

(define (mul-rat x y)
  (make-rat (* (numer x) (numer y))
	    (* (denom x) (denom y))))

(define (div-rat x y)
  (make-rat (* (numer x) (denom y))
	    (* (denom x) (numer y))))

(define (equal-rat? x y)
  (= (* (numer x) (denom y))
     (* (numer y) (denom x))))

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

