;; define fringe which takes a list and returns a list of all the leaves. 

(define x (list (list 1 2) (list 3 4)))

(define (fringe l)
  (cond ((null? l) l)
	((not (pair? (car l))) 
	 (append (list (car l)) (fringe (cdr l))))
	(else (append (fringe (car l)) (fringe (cdr l))))))


(newline)
(display (fringe x));  => (1 2 3 4)
(newline )
(display (fringe (list x x))) ; => (1 2 3 4 1 2 3 4)

