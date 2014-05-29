;; starting with the database and rules from 4.63  devise a rule for
;; adding "greats" to grandson relationships.
;; the facts would be something like ((great grandson) Adam Irad)
;; start by making a query that can tell if a list ends with
;; "grandson"
;; then you can make a rule like ((great . ?rel) ?x ?y) where ?rel
;; ends with 'grandson'

(load "4.4.1-4.63.scm")

(set! biblical-database 
      (append biblical-database
	      '(
		(rule (ends-in-grandson (grandson)))
		(rule (ends-in-grandson (?x . ?rest))
		      (ends-in-grandson ?rest))

		(rule ((grandson) ?x ?y) 
		      (grandson ?x ?y)) 
		(rule ((great . ?rel) ?x ?y) 
		      (and (ends-in-grandson ?rel) 
			   (son ?x ?z) 
			   (?rel ?z ?y))) 

		)))

(initialize-data-base biblical-database)
(query-driver-loop)
