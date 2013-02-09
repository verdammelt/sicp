;; Louis Reasoner write square-list like this but it returns the list
;; in reverse order- why?
(define (square-list items)
  (define (iter things answer)
    (if (null? things)
	answer
	(iter (cdr things)
	      (cons (square (car things))
		    answer))))
  (iter items '()))

;; it is reversed because we are consing the next item onto the list -
;; which prepends

;; Louis then tries to fix it by reversing answer and (square...) in
;; the cons above - it still doesn't work - why?

;; it still doesn't work because now he is consing an list onto an
;; item so the car is a list and the cdr is a single item - still not
;; the list he wants.

