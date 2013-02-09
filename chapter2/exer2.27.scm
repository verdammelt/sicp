;; modify reverse from 2.18 to produce a deep-reverse method

(define x (list (list 1 2) (list 3 4)))

(define (deep-reverse l)
  (cond ((null? l) l)
	((not (pair? (car l)))
	 (append (deep-reverse (cdr l)) (list (car l))))
	(else (append (deep-reverse (cdr l))
		      (list (deep-reverse (car l)))))))


(newline)
(display x)
(newline)
(display (reverse x))
(newline)
(display (deep-reverse x))


