;; exercise 3.24 - change the table implementation to use a
;; user-supplied equality predicate instead of relying upon assoc's
;; use of equal?
(define (make-table same-key?)
  (let ((local-table (list '*table*)))
    (define (assoc key records)
      (cond ((null? records) false)
	    ((same-key? key (caar records)) (car records))
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

(define t (make-table equal?))
((t 'insert!) 'a 1)
((t 'insert!) 'b 2)
((t 'insert!) 'c 3)
(newline)
(write-line ((t 'print)))
(display "lookup b:\n")
(write-line ((t 'lookup) 'b))

(define (fuzzy-equal? a b)
  (< (abs (- a b)) 2))
(define fuzzt (make-table fuzzy-equal?))
((fuzzt 'insert!) 1 'a)
((fuzzt 'insert!) 5 'b)
((fuzzt 'insert!) 9 'c)
(newline)
(write-line ((fuzzt 'print)))
(display "lookup 2:\n")
(write-line ((fuzzt 'lookup) 2))

;; exercise 3.25
;; generalize to a n-table - lookup and insert! take a list of keys
;; nothing to do here! just use equal? and the lists are keys.
;; an alternative is to write a bunch of code which can recursively
;; insert/lookup until it gets to a single key which is a
;; insert-1/lookup-1 type case
;; I choose no more code. - in fact i am removing this code here!
(define (make-n-table)
  (make-table equal?))

(define nt (make-n-table))
((nt 'insert!) '(a b c) 1)
((nt 'insert!) '(a b z) 2)
((nt 'insert!) '(x y z) 3)
((nt 'insert!) '(x y) 3)
(newline)
((nt 'print)) (newline)
(display ((nt 'lookup) '(x y))) (newline)
(display ((nt 'lookup) (list 'x 'y))) (newline)

