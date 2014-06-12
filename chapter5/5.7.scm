;; test machines made in 5.4 with simulator

(define expt-recurse
  (make-machine 
   '(b n val continue)
   (list (list '= =) (list '- -) (list '* *))
   '(controller 
     (assign continue (label done))
     
     expt-loop
     
     (test (op =) (reg n) (const 0))
     (branch (label base-case))
     
     (save continue)
     (assign n (op -) (reg n) (const 1))
     (assign continue (label after-recurse))
     (goto (label expt-loop))
     
     after-recurse
     (restore continue)
     (assign val (op *) (reg b) (reg val))
     (goto (reg continue))
     
     base-case
     (assign val (const 1))
     (goto (reg continue))
     
     done
     )
   ))

(define expt-iter
  (make-machine 
   '(b counter product)
   (list (list '= =) (list '- -) (list '* *))
   '(controller
     (assign product (const 1))
     
     expt-iter
     (test (op =) (reg counter) (const 0))
     (branch (label done))
     (assign counter (op -) (reg counter) (const 1))
     (assign product (op *) (reg product) (reg b))
     (goto (label expt-iter))
     
     done
     )
   ))
