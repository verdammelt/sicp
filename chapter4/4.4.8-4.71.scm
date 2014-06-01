;; why use delay in simple-query and disjoin?

;; it is because there could be an infinite loop as apply-rules coudl
;; eventually call simple-query again.
