;; Louis Reasoner's version of queens takes a LONG time to run.
;; 
;; His version looks like this:
;; (define (queen-cols k)
;;   (if (= k 0) (list empty-board)
;; 	(filter
;; 	 (lambda (positions) (safe? k positions))
;; 	 (flatmap
;; 	  (lambda (new-row)
;; 	    (map (lambda (rest-of-queens)
;; 		   (adjoin-position new-row k rest-of-queens))
;; 		 (queen-cols (- k 1))))
;; 	  (enumerate-interval 1 board-size)))))
;;
;; the correct version is:
;; (define (queen-cols k)
;;   (if (= k 0) (list empty-board)
;; 	(filter
;; 	 (lambda (positions) (safe? k positions))
;; 	 (flatmap
;; 	  (lambda (rest-of-queens)
;; 	    (map (lambda (new-row)
;; 		   (adjoin-position new-row k rest-of-queens))
;; 		 (enumerate-interval 1 board-size)))
;; 	  (queen-cols (- k 1))))))
;;
;; explain why his version is slow and if the correct version takes
;; time T how long will Louis' version take?
;;

;; answer: 
;;
;; 1) no longer tail-recursive and for every column C of the board it
;; will call queens-col C times
;;
;; 2) T^2 (?)
