;; complete this defintion for subset and explain why:
;; (define (subsets s)
;;   (if (null? s)
;;       (list nil)
;;       (let ((rest (subsets (cdr s))))
;; 	(append rest (map <??> rest)))))
(define nil (list))
(define (subsets s)
  (if (null? s) (list nil)
      (let ((rest (subsets (cdr s))))
	(append rest 
		(map 
		 (lambda (x) (cons (car s) x)) 
		 rest)))))

;; it works because we need to put the car of any s back into the answer
;; even when we get down to the end.

