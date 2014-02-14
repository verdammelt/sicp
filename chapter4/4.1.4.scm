;; Eva typed in a definition of map and it worked fine.
;; Louis installed map as a primitive and it didn't work.
;; why?

;; Because the map function takes a function parameter. The primitive
;; one cannot access functions defined in the evaluator while the one
;; defined in the evaluator of course can.
