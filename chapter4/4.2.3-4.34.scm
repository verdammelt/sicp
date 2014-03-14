;; modify driver loop to print out possibly infinite lazy lists.
;; I will chooose to only ever print up to 4 items of a list

;; in the interpreter:
(define (cons x y)
  (list 'lazy-list (lambda (m) (m x y))))
(define (car c)
  ((cadr c) (lambda (m p q) p)))
(define (cdr c)
  ((cadr c) (lambda (m p q) (list 'lazy-list q))))

(define (print-lazy-list l env)
  (define (print-some-items l n lim)
    (cond ((null? l) (display ""))
	  ((= n lim) (display "...)"))
	  (else (display (eval (car l) env))
		(print-some-items (eval (cdr l) env) (+ 1 n) lim))))
  (print-some-items l 0 4))

;; NOTE: untested.
