;; why does Louis Reasoner's version of outranked-by go into an infinite loop?

(rule (outranked-by ?staff-person ?boss)
      (or (supervisor ?staff-person ?boss)
	  (and (outranked-by ?middle-manager ?boss)
	       (supervisor ?staff-person ?middle-manager))))

;; because whether or not ?staff-person is supervisor for ?boss we 
;; will check (outranked-by ?middle-manager ?boss) with no constraint
;; at all upon ?middle-manager. So it does not reduce the problem set
;; and goes into an infinite loop. Doing the 
;; (supervisor ?staff-person ?middle-manager) clause first would
;; result in a constraint on ?staff-person and a reduction in the
;; problem and *maybe* we'd not have an infinite loop then.
