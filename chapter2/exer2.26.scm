(define x (list 1 2 3))
(define y (list 4 5 6))

;; what will be the result of:
(append x y) ; => (1 2 3 4 5 6)

(cons x y) ; => ((1 2 3) . (4 5 6))
;; wrong. should be: ((1 2 3) 4 5 6)

(list x y) ; ((1 2 3) ((4 5 6) . nil))
;; wrong. should be: ((1 2 3) (4 5 6))




