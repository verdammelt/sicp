;; The treatment of machine operations above permits them to operate
;; on labels as well as on constants and the contents of registers.
;; Modify the expression-processing procedures to enforce the
;; condition that operations can be used only with registers and
;; constants.

;; we need to modify make-operation-exp to be as follows:
(define (make-operation-exp exp machine labels operations)
  (let ((op (lookup-prim (operation-exp-op exp) operations))
        (aprocs
         (map (lambda (e)
		(if (or 
		     (constant-exp? e)
		     (register-exp? e))
		    (make-primitive-exp e machine labels)
		    (error "Operations only allowed on constants or registers -- ASSEMBLE" e)))
              (operation-exp-operands exp))))
    (lambda ()
      (apply op (map (lambda (p) (p)) aprocs)))))
