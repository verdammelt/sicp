;; define reverse
(define (reverse l)
  (define (rev l out)
    (if (null? l) out
	(rev (cdr l) (cons (car l) out))))
  
  (rev l '()))

(reverse '(1 2 3 4))

