;; compare the instructions generated when 'preserving' has been
;; modifed to always save/restore

(load "compiler.scm")
(load "pprint-compile.scm")

(set! label-counter 0)
(pprint-compile "preserving" (compile '(f (g x)) 'val 'next))

(define (preserving regs seq1 seq2)
  (if (null? regs)
      (append-instruction-sequences seq1 seq2)
      (let ((first-reg (car regs)))
	(preserving (cdr regs)
		    (make-instruction-sequence
		     (list-union (list first-reg)
				 (registers-needed seq1))
		     (list-difference (registers-modified seq1)
				      (list first-reg))
		     (append `((save ,first-reg))
			     (statements seq1)
			     `((restore ,first-reg))))
		    seq2))))

(set! label-counter 0)
(pprint-compile "non-preserving" (compile '(f (g x)) 'val 'next))

;; comparing the preserving with the non-preserving versions really
;; shows all extra save/restore calls before every function call in
;; many cases silly things like ...(restore x)(save x).. 
