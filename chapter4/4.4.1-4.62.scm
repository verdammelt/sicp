;; Define rules to implement the last-pair operation of exercise 2.17,
;; which returns a list containing the last element of a nonempty
;; list. Check your rules on queries such as (last-pair (3) ?x),
;; (last-pair (1 2 3) ?x), and (last-pair (2 ?x) (3)). Do your rules
;; work correctly on queries such as (last-pair ?x (3)) ?

(assert! (rule (last-pair (?x) (?x))))
(assert! (rule (last-pair (?u . ?v) (?x))
	       (last-pair ?v (?x))))
