;; Extend the evaluator to handle derived expressions such as cond,
;; let, and so on (section 4.1.2). You may ``cheat'' and assume that
;; the syntax transformers such as cond->if are available as machine
;; operations.28

;; COND
;; . Add to eval-dispatch:

(test (op cond?) (reg exp))
(branch (label ev-cond))

;; Then add:

ev-cond
(assign exp (op cond->if) (reg exp))
(goto (label eval-dispatch))

;; LET
;;  add to eval-dispatch:
(test (op let?) (reg exp))
(branch (label ev-let))

;; Then add:
ev-let
(assign exp (op let->lambda) (reg exp))
(goto (label eval-dispatch))
