;; Ben Bitdiddle thinks he is super smart and adds accumlation
;; functions to the system (sum, average, minimum etc). Which lets him
;; write a query like:
(sum ?amount
     (and (job ?x (computer programmer))
	  (salary ?x ?amount)))

;; which should find out the total payroll for all computer programs.
;; It is implemented by taking all the frames resulting from the query
;; and mapping over them.

;; Then Cy D. Fect comes in with the problem of the duplicate rules
;; from wheel and Ben realizes that the frames are not constrained to
;; be unique.

;; He could fix it by implementing an accumlation function which would
;; map over the frames and make sure they are unique based upon a
;; given value - such as ?x in the above cause or ?who in the wheel
;; case (exercise 4.65).

