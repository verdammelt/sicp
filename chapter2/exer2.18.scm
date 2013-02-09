;; define reverse
(define (reverse l)
  (define (rev l out)
    (if (null? l) out
	(rev (cdr l) (cons (car l) out))))
  
  (rev l '()))

(define (reverse-with-append l)
  (if (null? l) l
      (append (reverse-with-append (cdr l))
	      (list (car l)))))

(newline)
(display (reverse '(1 2 3 4)))
(newline)
(display (reverse-with-append '(1 2 3 4)))

