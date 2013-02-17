(load "sequences.scm")

;; count-leaves was defined as:
;; (define (count-leaves x)
;;   (cond ((null? x) 0)
;; 	((not (pair? x)) 1)
;; 	(else (+ (count-leaves (car x))
;; 		 (count-leaves (cdr x))))))

;; redefine it with accumulate in the form
;; (define (count-leaves t)
;;   (accumulate <??> <??> (map <??> <??>))
(define (count-leaves t)
  (accumulate (lambda (x y) (1+ y)) 
	      0 
	      (map <??> <??>)
	      ))

(define test-tree '(1 (2 3) (4 (5) (6 7))))

(newline)
(display 'test-tree===>)
(display test-tree)
(newline)
(display 'count-leaves-on-test-tree===>)
(display (count-leaves test-tree))
