;; Cy D. Fect thinks every item but the last must be forced when
;; evaluating a sequence since he is worried that some side-effects
;; might never take place. 

;; a. Ben Bitdiddle gives the for-each function
;; as an example of a program which works fine with the existing code:
(define (for-each proc items)
  (if (null? items)
      'done
      (begin (proc (car items))
	     (for-each proc (cdr items)))))

;; ;;; L-Eval input:
;; (for-each (lambda (x) (newline) (display x))
;;   (list 57 321 88))
;; 57
;; 321
;; 88
;; ;;; L-Eval value:
;; done

;; Q: why is Ben right?

;; A: The side-effect of outputing to the display will all be done
;; because 1) display is primitive (assuming) and 2) the way for-each
;; works the first item of the begin block ends up being fully
;; evaluated. 

;; b. Q: Cy thinks this will show the problem

(define (p1 x)
  (set! x (cons x '(2)))
  x)
(define (p2 x)
  (define (p e)
    e
    x)
  (p (set! x (cons x '(2)))))

;; What is the value of (p1 1) and (p2 1) with the original
;; eval-sequence and what is it with his proposed changes?

;; A: with the original eval (p1 1) results in (1 2) and (p2 1)
;; returns 1. With Cy's changes (p2 1) would return (1 2) because the
;; side-effect of the set (which was thunked because it was the
;; argument e will be forced).

;; c. Q: Cy says his change will not affect the for-each example. Why?

;; A: Because we have memoized the thunk forcing - forcing a thunk
;; again will not cause the side-effect to happen again.

;; d. Q: Should the interpreter use the original version or Cy's
;; version or something else? What do I think?

;; A: I think that for a normal order interpreter it should
;; consistently NOT force thunks until needed. So since the other item
;; in the sequence are 'not needed' they should not be forced.


