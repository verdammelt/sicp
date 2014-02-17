;; Draw diagrams of the environment in effect when evaluating the
;; expression <e3> in the procedure in the text, comparing how this
;; will be structured when definitions are interpreted sequentially
;; with how it will be structured if definitions are scanned out as
;; described. Why is there an extra frame in the transformed program?
;; Explain why this difference in environment structure can never make
;; a difference in the behavior of a correct program. Design a way to
;; make the interpreter implement the ``simultaneous'' scope rule for
;; internal definitions without constructing the extra frame.


;; why extra frame? because of the let block.

;; it doesn't matter - why? because it is all contained in the let
;; block - and doesn't affect the outer scope

;; how to do this without pulling out the extra scope: Change the
;; lambda with the internal defines to have extra parameters, one for
;; each define.
