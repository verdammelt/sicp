;; describe (list 1 (list 2 (list 3 4)))
;; with the result from the interpreter
(list 1 (list 2 (list 3 4))) ; => (1 (2 (3 4))) -- got this wrong :(

;; in box-and-pointer notation (i'll do dotted list)
(1 . (2 . (3 . (4 . nil))))

;; as a tree (i had a slightly different interpretation - more like dotted notiation again)
x--x--x--4
|  |  |  
1  2  3  
