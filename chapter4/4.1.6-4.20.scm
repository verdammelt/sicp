(define letrec-test 
  '(letrec ((even? 
	     (lambda (n) 
	       (if (= n 0) 
		   true 
		   (odd? (- n 1)))))
	    (odd? 
	     (lambda (n) 
	       (if (= n 0) 
		   false
		   (even? (- n 1))))))
     (even? 10)))

;; a. define letrec as a derived expression
;;
;; will simply define the letrec->let procedure which could (with some
;; other helper methods) be used in eval
(define letrec-bindings cadr)
(define letrec-binding-variable car)
(define letrec-binding-value cadr)
(define letrec-body caddr)

(define (letrec->let exp)
  (let ((body (letrec-body exp))
	(vars (map letrec-binding-variable (letrec-bindings exp)))
	(vals (map letrec-binding-value (letrec-bindings exp)))
	(unassigned '*unassigned*))
    (append (list 'let
		  (map (lambda (v) (list v unassigned)) vars))
	    (map (lambda (var val) (list 'set! var val)) vars vals)
	    (list body))))

;; b. Louis thinks that you don't need letrec - you can just use let.
;; he is wrong - because whose entire body is a let is like a function
;; with the let binding variables as parameters, initialized to the
;; binding values in the call to that function:
(define (f x)
  (let ((even? even-stuff-references-odd?)
	(odd? odd-stuff-references-even?))
    (body-of-f)))
;;==>
(define (f x)
  ((lambda (even? odd?) (body-of-f))
   even-stuff-references-odd?
   odd-stuff-references-even?))
;; but the parameters even? odd? are not the same symbols as those
;; referenced in even-stuff-references-odd? or
;; odd-stuff-references-even? and so this will not work.
;;
;; letrec works because it rewrites into a let and set! which makes
;; sure that the even? and odd? symbols are the same as those in the
;; definitions of those symbols

