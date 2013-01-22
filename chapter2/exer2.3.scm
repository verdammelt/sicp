;; NOTE: exer 2.2 will be helpful
(load "chapter2/exer2.2.scm")

;; define a representation for a rectangle on a plane define area &
;; perimeter such that they don't need to change if the defintion of
;; rectangle does

(define (make-rect h w) (cons h w))
(define (rect-height r) (car r))
(define (rect-width r) (cdr r))
(define (print-rect r)
  (newline)
  (display "RECT[h:")
  (display (rect-height r))
  (display ",w:")
  (display (rect-width r))
  (display "]"))

(define (rect-area r)
  (* (rect-height r) (rect-width r)))
(define (rect-perimeter r)
  (+ (* (rect-height r) 2) (* (rect-width r) 2)))

(define (verbose-rect-print r1)
  (print-rect r1)
  (newline)
  (display "area=")
  (display (rect-area r1))
  (newline)
  (display "perimeter=")
  (display (rect-perimeter r1)))

(define r1 (make-rect 2 4))
(verbose-rect-print r1)

;; now change the definition of the rectangle. to prove you did area &
;; perimeter well.

(newline)
(display "NEW DEFINITION")

(define (make-rect p1 p2) (cons p1 p2))
(define (rect-height r)
  (abs (- (y-coor (car r))
	  (y-coor (cdr r)))))
(define (rect-width r)
  (abs (- (x-coor (car r))
	  (x-coor (cdr r)))))

(define r1 (make-rect (make-point 0 0) (make-point 4 -2)))
(verbose-rect-print r1)


