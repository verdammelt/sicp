;; Given
(define (unless condition usual-value exceptional-value)
  (if condition exceptional-value usual-value))

(define (factorial n)
  (unless (= n 1)
    (* n (factorial (- n 1)))
    1))

;; Q: Will this work in an applicative order language?

;; A: No it will not. Because the language will evaluate each arguemnt
;; to unless before evaluating unless the argument (* n (factorial (-
;; n 1)) will be evaluated, resulting in another call to unless which
;; will again evaluate that argument etc. We will be in an infinite
;; loop of calling factorial with (- n 1) over and over again. n will
;; go below 1 because the unless will not be evaluated until its
;; arguments are completely evaluated.

;; Q: Will this work in a normal order language?

;; A: Yes it will. In a normal order language the (* n (factorial (- n
;; 1)) argument to unless will not be evaluated until it is needed. So
;; if n <=1 it will never be evaluated. We will not get into an
;; infinite loop here.
