;;; Alyssa P Hacker's system to do interval arithmatic
(define (add-interval x y)
  (make-interval (+ (lower-bound x) (lower-bound y))
		 (+ (upper-bound x) (upper-bound y))))
(define (mul-interval x y)
  (let ((p1 (* (lower-bound x) (lower-bound y)))
	(p2 (* (lower-bound x) (upper-bound y)))
	(p3 (* (upper-bound x) (lower-bound y)))
	(p4 (* (upper-bound x) (upper-bound y))))
    (make-interval (min p1 p2 p3 p4)
		   (max p1 p2 p3 p4))))

(define (div-interval x y)
  (mul-iterval x
	       (make-interval (/ 1.0 (upper-bound y))
			      (/ 1.0 (lower-bound y)))))

;; exer 2.7
;; here is make-iterval
(define (make-interval a b) (cons a b))
;; define upper-bound and lower-bound
(define (lower-bound x) (car x))
(define (upper-bound x) (cdr x))

;; exer 2.8
;; define sub-iterval (analogous to add-iterval)
(define (sub-interval x y)
  (make-iterval (- (lower-bound x) (upper-bound y))
		(- (upper-bound x) (lower-bound y))))

;; exer 2.9
;; the width of an interval is the difference between the upper and
;; lower bound 
(define (width-interval x)
  (- (upper-bound x) (lower-bound x)))

;; the width of (add-interval x y) or (sub-interval x y) is a function
;; of the width-interval of x and y 
;; (+ (width-interval x) (width-interval y))
;; but (mul-interval x y) or (div-interval x y) 
;; for example:
(define a (make-interval 1 2))
(define b (make-interval 2 4))
(width-interval (add-interval a b)) ; => 3
(width-interval (sub-interval a b)) ; => 3
(width-interval (mul-interval a b)) ; => 6
(width-interval (div-interval a b)) ; => .75

;; exer 2.10
;; Ben Bitdiddle says that div-interval has problems with intervals
;; spanning zero.
(define (new-div-interval x y)
  (if (and (<= (lower-bound y) 0)
	   (>= (upper-bound y) 0))
      (error "lower-bound spans zero")
      (mul-iterval x
		   (make-interval (/ 1.0 (upper-bound y))
				  (/ 1.0 (lower-bound y))))))
(define i1 (make-interval 10 20))
(define i2 (make-interval -1 1))
;; error if (new-div-interval i1 i2)

;; exer 2.11
;; Ben Bitdiddle says that by checking signs of the bounds one can
;; split mul-interval into 9 cases only 1 of which needs more than 2
;; multiplications. 
;; (just took it from Bill-the-Lizard - didn't bother to work it through)
(define (new-mul-interval x y)
  (let ((xlo (lower-bound x))
	(xhi (upper-bound x))
	(ylo (lower-bound y))
	(yhi (lower-bound y)))
    (cond ((and (>= xlo 0)
		(>= xhi 0)
		(>= ylo 0)
		(>= yhi 0))
	   ;; [+,+] * [+,+]
	   (make-interval (* xlo ylo) (* xhi yhi)))
	  ((and (<= xlo 0)
		(>= xhi 0)
		(<= ylo 0)
		(>= yhi 0))
	   ;; [-,-] * [-,-]
	   (make-interval (* xhi ylo) (* xhi yhi)))
	  ((and (>= xlo 0)
		(>= xhi 0)
		(<= ylo 0)
		(<= yhi 0))
	   ;; [+, +] * [-, -]
	   (make-interval (* xhi ylo) (* xlo yhi)))
	  ((and (<= xlo 0)
		(>= xhi 0)
		(>= ylo 0)
		(>= yhi 0))
	   ;; [-, +] * [+, +]
	   (make-interval (* xlo yhi) (* xhi yhi)))
	  ((and (<= xlo 0)
		(>= xhi 0)
		(<= ylo 0)
		(>= yhi 0))
	   ;; [-, +] * [-, +]
	   (make-interval (min (* xhi ylo) (* xlo yhi))
			  (max (* xlo ylo) (* xhi yhi))))
	  ((and (<= xlo 0)
		(>= xhi 0)
		(<= ylo 0)
		(<= yhi 0))
	   ;; [-, +] * [-, -]
	   (make-interval (* xhi ylo) (* xlo ylo)))
	  ((and (<= xlo 0)
		(<= xhi 0)
		(>= ylo 0)
		(>= yhi 0))
	   ;; [-, -] * [+, +]
	   (make-interval (* xlo yhi) (* xhi ylo)))
	  ((and (<= xlo 0)
		(<= xhi 0)
		(<= ylo 0)
		(>= yhi 0))
	   ;; [-, -] * [-, +]
	   (make-interval (* xlo yhi) (* xlo ylo)))
	  ((and (<= xlo 0)
		(<= xhi 0)
		(<= ylo 0)
		(<= yhi 0))
	   ;; [-, -] * [-, -]
	   (make-interval (* xhi yhi) (* xlo ylo))))))

