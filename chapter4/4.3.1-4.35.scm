;; write a method: an-integer-between which produces an integer
;; between two bounds 
(define (an-integer-between i j)
  (require (< i j))
  (amb i (an-integer-between (+ 1 i) j)))
