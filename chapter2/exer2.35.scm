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
	      (enumerate-tree t)
	      ;; (map <??> <??>) - not sure what to do here.
	      ))

(define test-tree '(1 (2 3) (4 (5) (6 7))))

(newline)
(display 'test-tree===>)
(display test-tree)
(newline)
(display 'count-leaves-on-test-tree===>)
(display (count-leaves test-tree))

;; bill the lizard solved it like so:
;; (define (count-leaves t)
;;   (accumulate +
;; 	      0 
;; 	      (map (lambda (x) 1) (enumerate-tree t))
;; 	      ))
;;
;; while it fits exactly into the requested solution I don't like it
;; much.
;; on the other hand it is less complex than my solution by using
;; simple addition of a string of 1's
;;
;; interesting how it is simpler but i dislike it.

