(rule (wheel ?person)
      (and (supervisor ?middle-manager ?person)
	   (supervisor ?x ?middle-manager)))

;; Given the above definition of wheel why does it return 
;; (Warbucks Oliver) multiple times when the query (wheel ?who) is run?

;; Because Warbucks supervises:
;; 1. Scrooge who supvervises Cratchet
;; 2. Bitdiddle who supervises Hacker
;; 3. Bitdiddle who supervises Fect
;; 4. Bitdiddle who supervises Tweakit

;; each path is taken and is reported as a separate case.
