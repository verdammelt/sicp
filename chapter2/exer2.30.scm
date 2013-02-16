;; define method square-tree which is like square-list but works on trees

;; define it directly (no higher-order functions)
(define (square-tree tree)
  (cond ((null? tree) (list))
	((not (pair? tree)) (* tree tree))
	(else (cons (square-tree (car tree)) (square-tree (cdr tree)))))
  )

;; define it with map and higher order functions
(define (square-tree-w/fn tree)
  (map (lambda (sub-tree)
	 (if (pair? sub-tree)
	     (square-tree sub-tree)
	     (* sub-tree sub-tree)))
       tree))

(define tree (list 1 (list 2 3) (list 4 5)))

(newline)
(display 'square-tree==>)
(display (square-tree tree))

(newline)
(display 'square-tree-w/fn==>)
(display (square-tree-w/fn tree))
