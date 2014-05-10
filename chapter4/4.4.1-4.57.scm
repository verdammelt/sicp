;; Define a rule that says that person 1 can replace person 2 if
;; either person 1 does the same job as person 2 or someone who does
;; person 1's job can also do person 2's job, and if person 1 and
;; person 2 are not the same person. 

;; assumes that there is a can-do-job rule
(rule (replace ?person1 ?person2)
      (and (job ?person1 ?job1)
	  (job ?person2 ?job2)
	  (or (same ?job1 ?job2)
	      (can-do-job ?job1 ?job2))
	  (not (same ?person1 ?person2))))


;; Using your rule, give queries that find the following:

;; a. all people who can replace Cy D. Fect;
(replace (Fect Cy D) ?x)

;; b. all people who can replace someone who is being paid more than
;; they are, together with the two salaries
(and (salary ?person1 ?salary1)
     (salary ?person2 ?salary2)
     (replace ?person1 ?person2)
     (lisp-value > ?salary1 ?salary2))
