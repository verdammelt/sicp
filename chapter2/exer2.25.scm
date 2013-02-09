;; find combinations of car/cdr which get 7 from the following
;; 
(define one '(1 3 (5 7) 9))

(define two '((7)))

(define three '(1 (2 (3 (4 (5 (6 7)))))))

(car (cdr (car (cdr (cdr one)))))

(car (car two))

(car (cdr (car (cdr (car (cdr (car (cdr (car (cdr (car (cdr three))))))))))))

