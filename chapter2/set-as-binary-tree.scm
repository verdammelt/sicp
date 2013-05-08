(define (entry tree) (car tree))
(define (left-branch tree) (cadr tree))
(define (right-branch tree) (caddr tree))
(define (make-tree entry left right)
  (list entry left right))

(define (element-of-set? x set)
  (cond ((null? set) false)
	((= x (entry set)) true)
	((< x (entry set))
	 (element-of-set? x (left-branch set)))
	((> x (entry set))
	 (element-of-set? x (right-branch set)))))

(define (adjoin-set x set)
  (cond ((null? set) (make-tree x '() '()))
	((= x (entry set)) set)
	((< x (entry set))
	 (make-tree (entry set)
		    (adjoin-set x (left-branch set))
		    (right-branch set)))
	((> x (entry set))
	 (make-tree (entry set)
		    (left-branch set)
		    (adjoin-set x (right-branch set))))))

;; exercise 2.63:
(define (tree->list-1 tree)
  (if (null? tree)
      '()
      (append (tree->list-1 (left-branch tree))
	      (cons (entry tree)
		    (tree->list-1 (right-branch tree))))))
(define (tree->list-2 tree)
  (define (copy-to-list tree result-list)
    (if (null? tree)
	result-list
	(copy-to-list (left-branch tree)
		      (cons (entry tree)
			    (copy-to-list (right-branch tree)
					  result-list)))))
  (copy-to-list tree '()))

;; example trees
(define tree-1 
  (make-tree 7 
	     (make-tree 3 
			(make-tree 1 '() '()) 
			(make-tree 5 '() '())) 
	     (make-tree 9 
			'() 
			(make-tree 11 '() '()))))
(define tree-2 
  (make-tree 3 
	     (make-tree 1 '() '()) 
	     (make-tree 7 
			(make-tree 5 '() '()) 
			(make-tree 9 '() 
				   (make-tree 11 '() '())))))
(define tree-3 
  (make-tree 5 
	     (make-tree 3 
			(make-tree 1 '() '()) 
			'())
	     (make-tree 9
			(make-tree 7 '() '())
			(make-tree 11 '() '()))))

;; a) do these produce the same result for the same inputs? if not how
;; are they different? what do they do for the trees listed in figure
;; 2.16? 
;; I think they produce the same outputs with the same inputs.

;; b) do they have the same order of growth?
;; The second appears to be tail recursive.

;; exercise 2.64
(define (list->tree elements)
  (car (partial-tree elements (length elements))))
(define (partial-tree elts n)
  (if (= n 0)
      (cons '() elts)
      (let ((left-size (quotient (- n 1) 2)))
	(let ((left-result (partial-tree elts left-size)))
	  (let ((left-tree (car left-result))
		(non-left-elts (cdr left-result))
		(right-size (- n (+ left-size 1))))
	    (let ((this-entry (car non-left-elts))
		  (right-result (partial-tree (cdr non-left-elts)
					      right-size)))
	      (let ((right-tree (car right-result))
		    (remaining-elts (cdr right-result)))
		(cons (make-tree this-entry left-tree right-tree)
		      remaining-elts))))))))

;; a. Write a short paragraph explaining as clearly as you can how
;; partial-tree works. Draw the tree produced by list->tree for the
;; list (1 3 5 7 9 11).

;; It splits the list in 'half' around a central element (the left
;; side will always be shorter. Then creates a tree from that,
;; recursing down the left and right sides.

;; a 'drawing':
;;   5
;;  / \
;; 1   \
;;  \   \
;;   3   9
;;      / \
;;     7   11


;; b. What is the order of growth in the number of steps required by
;; list->tree to convert a list of n elements? 
;; Order of logn?

;; exercise 2.65 - implement union & intersection
(define (union-set set1 set2)
  (define (add-list-to-tree tree list)
    (if (null? list) 
	tree
	(add-list-to-tree (adjoin-set (car list) tree) (cdr list))
	))
  (add-list-to-tree set1 (tree->list-2 set2)))

(define (intersection-set set1 set2)
  (define (helper old-tree items new-tree)
    (cond ((null? items) new-tree) 
	  ((element-of-set? (car items) old-tree)
	   (helper old-tree (cdr items) (adjoin-set (car items) new-tree)))
	  (else (helper old-tree (cdr items) new-tree))))
  (helper set1 (tree->list-2 set2) '()))


;;;
;;; Well... looking at Bill the Lizard's answers I think I would get
;;; pretty low marks on this assignment.
;;; not going to redo it however.
;;;
