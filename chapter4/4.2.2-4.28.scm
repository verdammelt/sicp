;; Q: Why does eval need to call actual-value on the operator before
;; calling apply?

;; A: It needs to because the operator might be an expresion which
;; needs evaluation and that expression might return a thunk.

;; For example:
(define function factorial)
(function 5)

