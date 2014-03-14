;; Q: give examples of how these new lazy streams are even lazier than
;; those in chapter 3 - and how could we use that to our advantage?

;; A: As stated in the text even car & cdr are not forcing their return
;; values, so one could have an infinite list of infinite lists:

; (map (lambda (x) (scale-list integers x)) integers)

