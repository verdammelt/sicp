;; In the multiple dwelling problem, how many sets of assignments are
;; there of people to floors, both before and after the requirement
;; that floor assignments be distinct? 

;; if not distinct there is a maximum of (/ 9! (* 5! 4!)) = 126
;; if distinct there is a maximum of 121 (above - 5)
;; This is before the other restrictions are set.

;; It is very inefficient to generate all possible assignments of
;; people to floors and then leave it to backtracking to eliminate
;; them. For example, most of the restrictions depend on only one or
;; two of the person-floor variables, and can thus be imposed before
;; floors have been selected for all the people. Write and demonstrate
;; a much more efficient nondeterministic procedure that solves this
;; problem based upon generating only those possibilities that are not
;; already ruled out by previous restrictions. (Hint: This will
;; require a nest of let expressions.)

;; decided to leave the impossible floors (i.e. 5 for baker) in their
;; amb choices because I though it better to put all restrictions in
;; the code as opposed to the initial choices.
(define (more-efficient-multiple-dwelling)
  (let ((baker (amb 1 2 3 4 5)))
    (require (not (= baker 5)))
    (let ((cooper (amb 1 2 3 4 5)))
      (require (not (= baker cooper)))
      (require (not (= cooper 1)))
      (let ((fletcher (amb 1 2 3 4 5)))
	(require (not (= baker fletcher)))
	(require (not (= cooper fletcher)))
	(require (not (= fletcher 1)))
	(require (not (= fletcher 5)))
	(require (not (= (abs (- fletcher cooper)) 1)))
	(let ((miller (amb 1 2 3 4 5)))
	  (require (not (= baker miller)))
	  (require (not (= cooper miller)))
	  (require (not (= fletcher miller)))
	  (require (> miller cooper))
	  (let ((smith (amb 1 2 3 4 5)))
	    (require (not (= baker smith)))
	    (require (not (= cooper smith)))
	    (require (not (= fletcher smith)))
	    (require (not (= miller smith)))
	    (require (not (= (abs (- smith fletcher)) 1)))
	    (list (list 'baker baker)
		  (list 'cooper cooper)
		  (list 'fletcher fletcher)
		  (list 'miller miller)
		  (list 'smith smith))))))))
