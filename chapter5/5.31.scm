;; In evaluating a procedure application, the explicit-control
;; evaluator always saves and restores the env register around the
;; evaluation of the operator, saves and restores env around the
;; evaluation of each operand (except the final one), saves and
;; restores argl around the evaluation of each operand, and saves and
;; restores proc around the evaluation of the operand sequence. For
;; each of the following combinations, say which of these save and
;; restore operations are superfluous and thus could be eliminated by
;; the compiler's preserving mechanism:

;; (f 'x 'y)
;; looking up f needs env (but will not change it)
;; computing 'x and 'y do not need env or argl - but do need proc (because ' is (quote...))
;; only the saving/restoring of proc is needed (and that depends on if evaluating (quote x) will change proc

;; ((f) 'x 'y)
;; computing (f) will need env and proc and argl, it will possibly modify all of these.
;; computing 'x and 'y will need no registers (except maybe proc - depends on how quote is implemented.

;; (f (g 'x) y)
;; looking up env will need env but not change it.
;; evaluating (g 'x) will need proc and env and maybe modify them.
;; evaluating y will need env.

;; (f (g 'x) 'y)
;; same as above but 'y doesn't need env.
