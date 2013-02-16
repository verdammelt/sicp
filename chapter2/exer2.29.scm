(load-option 'format)

;; a binary mobile is defined as follows. Each side is a branch
(define (make-mobile left right)
  (list left right))

;; a branch is defined as a rod of length with either a weight or
;; another mobile on it.  (structure is either a number or a mobile)
(define (make-branch length structure)
  (list length structure))


;; exer 2.29a - define the selectors
(define left-branch car)
(define right-branch cadr)
(define branch-length car)
(define branch-structure cadr)

;; exer 2.29b


(define (branch-weight b)
  (let ((structure (branch-structure b)))
    (if (not (pair? structure)) structure
	(total-weight structure))))

(define (total-weight m)
  (if (null? m) 0
      (+ (branch-weight (left-branch m))
	 (branch-weight (right-branch m)))))

(define test-mobile 
  (make-mobile (make-branch 5 3) 
	       (make-branch 2 (make-mobile (make-branch 2 1) 
					   (make-branch 3 5)))))

(format #t "total weight of test mobile (should be 9): ~A~%" 
	(total-weight test-mobile))

;; exer 2.29c a mobile is balanced if the torque of the two branches
;; are equal (and all submobiles are balanced) 
;; the torque of a branch is the length times the weight

(define (balanced? m)
  (define (branch-torque b)
    (* (branch-length b) (branch-weight b)))
  (define (branch-balanced? b)
    (let ((structure (branch-structure b))) 
      (or (not (pair? structure)) (balanced? structure))))
  
  (let ((left (left-branch m))
	(right (right-branch m)))

    (and (= (branch-torque left)
	    (branch-torque right))
	 (branch-balanced? left)
	 (branch-balanced? right))))

(define test-balanced-mobile
  (make-mobile (make-branch 5 (make-mobile (make-branch 2 2)
					   (make-branch 1 4)))
	       (make-branch 5 (make-mobile (make-branch 5 1)
					   (make-branch 1 5)))))

(define test-balanced-mobile2
  (make-mobile (make-branch 1 (make-mobile (make-branch 2 2)
					   (make-branch 4 1)))
	       (make-branch 3 1)))

(format #t "balanced? test-mobile (false) => ~A~%" (balanced? test-mobile))
(format #t "balanced? test-balanced-mobile (true) => ~A~%" (balanced? test-balanced-mobile))
(format #t "balanced? test-balanced-mobile2 (true) => ~A~%" (balanced? test-balanced-mobile2))


