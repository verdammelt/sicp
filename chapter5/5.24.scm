;; Implement cond as a new basic special form without reducing it to
;; if. You will have to construct a loop that tests the predicates of
;; successive cond clauses until you find one that is true, and then
;; use ev-sequence to evaluate the actions of the clause.

ev-cond
(save exp)
(save env)
(save continue)
(assign continue (labe ev-cond-decide))

;; exp contains entire (cond (((p1) (a1)) ((p2) (a2)) (else (an))))
(assign exp (op rest-exps) (reg exp)) 	; all conditions & consequents
ev-cond-test-loop
(assign uenv (op first-exps) (reg exp)) ; first condition & consequent
(assign exp (op rest-exps) (reg exp))	; the rest of the conditions & consequents
(save exp)
(assign exp (op first-exps) (reg unev))	; the first condition
(assign unev (op rest-exps) (reg unev)) ; the consequent
(save unev)
(goto (label eval-dispatch))
ev-cond-decide
(restore unev) 				; the consequent
(test (op true?) (reg val))
(branch (label ev-cond-found-it))
ev-cond-not-this-one
(restore exp)
(goto (label ev-cond-test-loop))
ev-cond-found-it
(restore exp)				; pop off the rest
(assign exp (reg uenv)) 		; put the consequent into place
(restore continue)
(goto (label ev-sequence))		; eval consequent

