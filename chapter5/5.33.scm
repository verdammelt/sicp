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

;; set label-counter to 0 each time to make sure the outputs are as
;; diffable as possible.
(set! label-counter 0)
(pprint-compile "factorial" 
		(compile
		 '(define (factorial n)
		    (if (= n 1)
			1
			(* (factorial (- n 1)) n))) 
		 'val 'next))

(set! label-counter 0)
(pprint-compile "factorial-alt" 
		(compile '(define (factorial-alt n)
			    (if (= n 1)
				1
				(* n (factorial-alt (- n 1))))) 
			 'val 'next))

;; the difference between the compiled code of the two variants of
;; factorial are because in the first we need to save env because the
;; recursive call might change the env, in the second we need to save
;; argl because the calling of the function will change argl.
;;
;; ultimately they sem to have the same number of instructions so I
;; don't think there is any real difference for efficiency.
