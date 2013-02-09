(load-option 'format)
;; exer 2.19
(define (cc amount coin-values)
  (cond ((= amount 0) 1)
	((or (< amount 0) (no-more? coin-values)) 0)
	(else 
	 (+ 
	  (cc amount
	      (except-first-denomination coin-values))
	  (cc (- amount
		 (first-denomination coin-values))
	      coin-values)))))

(define (no-more? coins) (null? coins))
(define (first-denomination coins) (car coins))
(define (except-first-denomination coins) (cdr coins))

(define us-coins (list 50 25 10 5 1))
(define uk-coins (list 100 50 20 10 5 2 1 0.5))

(newline)
(display (cc 100 us-coins))

;; the order of the coin lists don't matter because the else branch
;; tries each coin in turn ultimately.
