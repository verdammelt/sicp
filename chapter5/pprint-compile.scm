(define (pprint-compile filename inst-seq)
  (define (pprint-list l)
    (if (null? l) (newline)
	(begin (display (car l))
	       (newline)
	       (pprint-list (cdr l)))))

  (let ((needs (registers-needed inst-seq))
	(modified (registers-modified inst-seq))
	(statements (statements inst-seq)))
    (with-output-to-file filename 
      (lambda ()
	(display "NEEDS: ")
	(display needs)
	(newline)

	(display "MODIFIES: ")
	(display modified)
	(newline)

	(display "STATEMENTS:") 
	(newline)
	(pprint-list statements))))

  'purty-aint-she?)
