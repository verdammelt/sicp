;; given this procedure
(let ((a 1))
  (define (f x)
    (define b (+ a x))
    (define a 5)
    (+ a b))
  (f 10))

;; what should its result be?

;; Ben thinks 16 because he sees it handled sequentially

;; Alyssa thinks that these must be handled simultaneously and so it
;; should get an error since a is undefined at the time b is bound.

;; Eva thinks also it is simultaneous but that means that a is 5 when
;; b is defined and thus the answer is 20.

;; Which do I agree with? and can I design a way to make it work like Eva?

;; I can argue for all three of these unfortunately. I agree with the
;; footnote that Eva's way is probably best but hard/impossible to
;; implement
