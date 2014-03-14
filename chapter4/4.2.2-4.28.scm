;; Q: Why does eval need to call actual-value on the operator before
;; calling apply?

;; A: It needs to because the operator might be an expresion which
;; needs evaluation and that expression might return a thunk.

;; For example:
(define function factorial)
(function 5)

;; better example found on the web:
(define (g x) (+ x 1)) 
(define (f g x) (g x)) 

;; without actual-value forcing - g will be a thunk and you can't
;; call a thunk like a function (in (g x)).
