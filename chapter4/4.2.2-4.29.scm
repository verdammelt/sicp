;; Given:
(define count 0)
(define (id x)
  (set! count (+ count 1))
  x)

;; (define (square x)
;;   (* x x))
;; ;;; L-Eval input:
;; (square (id 10))
;; ;;; L-Eval value:
;; <response>

;; without memoization: 100
;; with memoization: 100
;; memoization doesn't affect the value of square for argument (id 10)

;; ;;; L-Eval input:
;; count
;; ;;; L-Eval value:
;; <response>

;; without memoization: 2
;; with memoization: 1
;; because (id 10) is only called once.

;; Q: exhibit a program that will run much slower without memoization:

;; A: A program which applies an function that is slow and thunked

(define (super-slow-x x)	       
  (sleep 2 'days)			; pretend such a thing exists
  x)

(define (cube x)
  (* x x x))

(cube (super-slow-x 3))

;; this would be insanely slow since each time cube wants to use 'x'
;; it will need to force it and forcing it will cause a 2 day delay.
;; That will result in a total of a 6 day delay. With memoization it
;; would only take 2 days.


