;; define for-each
(define (for-each fn l)
  (if (null? (cdr l)) (fn (car l))
      (and (fn (car l))
	   (for-each fn (cdr l)))))

(for-each (lambda (x) (newline) (display x)) 
	  (list 57 321 88))
