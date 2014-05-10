;; Define a rule that says that a person is a ``big shot'' in a
;; division if the person works in the division but does not have a
;; supervisor who works in the division.
(rule (bigshot ?person ?division)
      (and (job ?person (?division . ?subdivision))
	   (or (not supervisor ?person ?boss) ; may not have a boss at all!
	       (and (supervisor ?person ?boss)
		    (not (job ?boss (?division . ?ignore)))))))
