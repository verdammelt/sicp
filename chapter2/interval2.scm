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
  (make-interval (- c (* c p)) (+ c (* c p))))

(define (percent i)
  (abs (/ (- (center i) (lower-bound i)) (center i))))



