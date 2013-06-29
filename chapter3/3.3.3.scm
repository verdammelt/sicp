;; exercise 3.24 - change the table implementation to use a
;; user-supplied equality predicate instead of relying upon assoc's
;; use of equal?
(define (make-table)
  (let ((local-table (list '*table*)))
    (define (assoc key records)
      (cond ((null? records) false)
	    ((equal? key (caar records)) (car records))
	    (else (assoc key (cdr records)))))
    (define (print) (display local-table))
    (define (lookup key)
      (let ((record (assoc key (cdr local-table))))
	(if record (cdr record) false)))
    (define (insert! key value)
      (let ((record (assoc key (cdr local-table))))
	(if record
	    (set-cdr! record value)
	    (set-cdr! local-table (cons (cons key value) 
					(cdr local-table))))))
    (define (dispatch m) 
      (cond ((eq? m 'lookup) lookup)
	    ((eq? m 'insert!) insert!)
	    ((eq? m 'print) print)
	    (else (error "Unknown operation -- table " m))))
    dispatch))

(define t (make-table))
((t 'insert!) 'a 1)
((t 'insert!) 'b 2)
((t 'insert!) 'c 3)
(newline)
(write-line ((t 'print)))
(display "lookup b:\n")
(write-line ((t 'lookup) 'b))


