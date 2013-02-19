(load "sequences.scm")

;; define accumulate-n like accumulate but takes as third argument a
;; sequence of sequences. It applies its function to the first item
;; from each sequence, then the second item from each function etc.
;; (define (accumulate-n op init seqs)
;;   (if (null? (car seqs)) nil
;;       (cons (accumulate op init <???>)
;; 	    (accumualte-n op init <???>))))
(define (accumulate-n op init seqs)
  (define (map-seqs fn seqs) 
    (accumulate (lambda (x y) (cons (fn x) y)) nil seqs))

  (if (null? (car seqs)) nil
      (cons (accumulate op init (map-seqs car seqs))
	    (accumulate-n op init (map-seqs cdr seqs)))))

(define test-seqs (list (list 1 2 3) 
			(list 4 5 6)
			(list 7 8 9)
			(list 10 11 12)))

(newline)
(display 'testing-accumulate-n===>)
(display (accumulate-n + 0 test-seqs)) 
(newline)
(display "should have been '(22 26 30)")
