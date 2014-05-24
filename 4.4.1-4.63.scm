;; Given this database
(define biblical-database 
  '(
    (son Adam Cain)
    (son Cain Enoch)
    (son Enoch Irad)
    (son Irad Mehujael)
    (son Mehujael Methushael)
    (son Methushael Lamech)
    (wife Lamech Ada)
    (son Ada Jabal)
    (son Ada Jubal)
    

    ;; Formulate rules such as ``If S is the son of F, and F is the son of
    ;; G, then S is the grandson of G'' and ``If W is the wife of M, and S
    ;; is the son of W, then S is the son of M'' (which was supposedly
    ;; more true in biblical times than today) that will enable the query
    ;; system to find the grandson of Cain; the sons of Lamech; the
    ;; grandsons of Methushael. (See exercise 4.69 for some rules to
    ;; deduce more complicated relationships.)

    (rule (son ?f ?s) (and (wife ?f ?m) (son ?m ?s)))
    (rule (grandson ?g ?s) (and (son ?f ?s) (son ?g ?f)))
    )
  )
