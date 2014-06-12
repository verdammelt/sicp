;; Specify register machines that implement each of the following
;; procedures. For each machine, write a controller instruction
;; sequence and draw a diagram showing the data paths.

;; a. Recursive exponentiation:

;; (define (expt b n)
;;   (if (= n 0)
;;       1
;;       (* b (expt b (- n 1)))))

(controller 
 (assign b (op read))
 (assign n (op read))
 (assign continue (label done))

 expt-loop

 (test (op =) (reg n) (const 0))
 (branch (label base-case))

 (save continue)
 (assign n (op -) (reg n) (const 1))
 (assign continue after-recurse)
 (goto expt-loop)

 after-recurse
 (restore continue)
 (assign val (op *) (reg b) (reg val))
 (goto (reg continue))

 base-case
 (assign val (const 1))
 (goto (reg continue))

 done
 (perform (op print) (reg val))
 )

;; b. Iterative exponentiation:

;; (define (expt b n)
;;   (define (expt-iter counter product)
;;     (if (= counter 0)
;;         product
;;         (expt-iter (- counter 1) (* b product))))
;;   (expt-iter n 1))

(controller
 (assign b (op read))
 (assign counter (op read)) 
 (assign product (const 1))

 expt-iter
 (test (op =) (reg counter) (const 0))
 (branch done)
 (assign counter (op -) (reg counter) (const 1))
 (assign product (op *) (reg product) (reg b))
 (goto expt-iter)

 done
 (perform (op print) (reg product)))
