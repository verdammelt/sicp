;; a recursive factorial procedure without letrec or define
(display 'factorial-10)
(newline)
(display 
 ((lambda (n)
    ((lambda (fact)
       (fact fact n))
     (lambda (ft k)
       (if (= k 1)
	   1
	   (* k (ft ft (- k 1)))))))
  10))

;; a. check that this works then write something similar for
;; fibonnacci numbers.  
;;
;; it works by creating a function which takes a function ft and a
;; number k. This function is the usual factorial procedure. To
;; bootstrap it however there is another function which takes a
;; function fact and calls that with two arguments fact and n (same
;; pattern as in the function taking ft). This is called with the
;; previous lambda as its argument. This is then all wrapped in a
;; function taking an argument n which is called with 10.
;; 
;; A fibonacci algorithm done in this style would be:
(display 'fibonacci-6) (newline)
(display 
 ((lambda (n)
    ((lambda (fib)
       (fib fib n))
     (lambda (fibfn a)
       (cond ((< a 2) 1)
	     (else (+ (fibfn fibfn (- a 1)) 
		      (fibfn fibfn (- a 2))))))))
  6)) (newline)

;; b. Consider:
;; (define (f x)
;;   (define (even? n)
;;     (if (= n 0)
;; 	true
;; 	(odd? (- n 1))))
;;   (define (odd? n)
;;     (if (= n 0)
;; 	false
;; 	(even? (- n 1))))
;;   (even? x))
;;
;; Fill in the missing parts of the following to finish the definition
;; without letrec or internal defines
;; (define (f x)
;;   ((lambda (even? odd?)
;;      (even? even? odd? x))
;;    (lambda (ev? od? n)
;;      (if (= n 0) true (od? <??> <??> <??>)))
;;    (lambda (ev? od? n)
;;      (if (= n 0) false (ev? <??> <??> <??>)))))
;;
(define (f x)
  ((lambda (even? odd?)
     (even? even? odd? x))
   (lambda (ev? od? n)
     (if (= n 0) true (od? ev? od? (- n 1))))
   (lambda (ev? od? n)
     (if (= n 0) false (ev? ev? od? (- n 1))))))

(display 'f-5) (newline)
(display (f 5)) (newline)
(display 'f-6) (newline)
(display (f 6)) (newline)
