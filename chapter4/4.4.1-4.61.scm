;; Given these rules:
(rule (?x next-to ?y in (?x ?y . ?u)))
(rule (?x next-to ?y in (?v . ?z))
      (?x next-to ?y in ?z))

;; What will the response be to the following queries?

(?x next-to ?y in (1 (2 3) 4))
;; 1 next-to (2 3)
;; (2 3) next-to 4

(?x next-to 1 in (2 1 3 1))
;; 2 next-to 1
;; 3 next-to 1
