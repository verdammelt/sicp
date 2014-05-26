;; define a reverse query which will return the input list reversed:
;; (reverse (1 2 3) ?x) => (reverse (1 2 3) (3 2 1))
;; (hint - use append-to-form)
;; Can my query handle both (reverse (1 2 3) ?x) and (reverse ?x (1 2 3))

(define reverse-database
  '(
    (rule (append-to-form () ?y ?y))
    (rule (append-to-form (?u . ?v) ?y (?u . ?z))
	  (append-to-form ?v ?y ?z))
    

    (reverse () ())
    (rule (reverse ?x ?y)
	  (and (append-to-form (?first) ?rest ?x)
	       (append-to-form ?rev-rest (?first) ?y)
	       (reverse ?rest ?rev-rest)))
    )
  )

;; the query (reverse (1 2 3) ?x) goes into an infinite loop but the
;; other direction (reverse ?x (1 2 3)) returns the right answer.

