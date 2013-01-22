;;; define segments which are made up of two points
;;; then with this definition define a midpoint-segment procedure
;;; (the midpoint of a segment is the point which is at the average x
;;; and average y of the segment.)
(define (make-segment p1 p2) (cons p1 p2))
(define (start-segment s) (car s))
(define (end-segment s) (cdr s))

(define (make-point x y) (cons x y))
(define (x-coor p) (car p))
(define (y-coor p) (cdr p))

(define (print-point p)
  (newline)
  (display "(")
  (display (x-coor p))
  (display ",")
  (display (y-coor p))
  (display ")"))

(define (midpoint-segment s)
  (let ((average-x (average (x-coor (start-segment s))
			    (x-coor (end-segment s))))
	(average-y (average (y-coor (start-segment s))
			    (y-coor (end-segment s)))))
    (make-point average-x average-y)))


