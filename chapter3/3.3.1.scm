;; exercise 3.16
(define (count-pairs x)
  (if (not (pair? x))
      0
      (+ (count-pairs (car x))
	 (count-pairs (cdr x))
	 1)))

;; define troublesome items for this
;; one that returns 3
(define returns-3 '(a b c))
;; one that returns 4
(define returns-4 (let ((x '(a))) (list x x)))
;; one that returns 7
(define returns-7 (let ((x '(a))) (let ((y (cons x x))) (cons y y))))

;; one that never returns
(define returns-never (let ((x (list 'a))) (set-cdr! x x) x))

;; exercise 3.17
;; define a correced version of the above.
(define (count-pairs-better x)
  (let ((seen (list)))
    (define (helper x)
      (if (or (not (pair? x))
	      (memq x seen))
	  0
	  (begin (set! seen (cons x seen))
		 (+ (helper (car x))
		    (helper (cdr x))
		    1))))
    (helper x)))

;; exercise 3.18
;; make a method that detects a cycle in a list
(define returns-a-cycle (let ((x (list 'a))) (set-cdr! (last-pair x) x) x))
(define (has-cycle? x)
  (let ((seen (list)))
    (define (helper x)
      (cond ((not (pair? x)) 'NO-CYCLE-HERE)
	    ((memq (cdr x) seen) 'OMG-CYCLE)
	    (else (set! seen (cons (cdr x) seen))
		  (helper (cdr x)))))
    (helper x)))

