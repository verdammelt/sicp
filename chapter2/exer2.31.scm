;; abstract answer from 2.30 to make a map-tree method so that
;; square-tree could be defined as: (define (square-tree tree) (map-tree square tree))

;; square-tree was defined as: 
;; (define (square-tree-w/fn tree)
;;   (map (lambda (sub-tree)
;; 	 (if (pair? sub-tree)
;; 	     (square-tree sub-tree)
;; 	     (* sub-tree sub-tree)))
;;        tree))

(define (map-tree fn tree)
  (map (lambda (sub-tree)
	 (if (pair? sub-tree)
	     (map-tree fn sub-tree)
	     (fn sub-tree)))
       tree))

(define (square-tree tree) (map-tree square tree))

(define tree (list 1 (list 2 3) (list 4 5)))

(newline)
(display 'square-tree==>)
(display (square-tree tree))
