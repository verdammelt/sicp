(load "interval.scm")

;; Alyssa realizes that the intervals need to be defined as a 'center'
;; and 'width'. 
(define (make-center-width c w)
  (make-interval (- c w) (+ c w)))
(define (center i)
  (/ (+ (lower-bound i) (upper-bound i)) 2))
(define (width i)
  (/ (- (upper-bound i) (lower-bound i)) 2))

;; but... the users (engineers) want to define a center an a
;; percentage.
;; (define this)
(define (make-center-percent c p)
  (make-center-width c (* c (/ p 100.0))))

(define (percent i)
  (* 100.0 (/ (width i) (center i))))

;; exer 2.13 
;; assuming small percentages then a simple formula for
;; approximate percentage tolerance of the product of two intervals
;; can be expressed in terms of the tolerances of the factors. Assume
;; all numbers are positive.
;
; if x and y are intervals with small percentages then the upper and
; lower bounds of those numbers are very close to their centers cx and
; cy. The product of those numbers would be an interval whose lower
; bound would be (* xlo ylo) and upper bound (* xhi yhi). But with
; very small percentages that would be approximatley (* cx cy) in both
; cases. 
;; the percentage of the product would be approximately (* px py)
;; WRONG. (+ px py) :(


