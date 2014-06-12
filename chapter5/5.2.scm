;; Use the new notatin to define:
;; 
;; (define (factorial n)
;;   (define (iter product counter)
;;     (if (> counter n)
;;         product
;;         (iter (* counter product)
;; 	      (+ counter 1))))
;;   (iter 1 1)) 

(controller 
 (assign p (const 1))
 (assign c (const 1))

 test-n
 (test (op >) (reg c) (reg n))
 (branch (label done))
 (assign x (op *) (reg p) (reg c))
 (assign y (op +) (reg c) (const 1))
 (assign p (reg x))
 (assign c (reg y))
 (goto (label test-n))

 done)
