(define fold-right accumulate)

(define (fold-left op initial sequence)
  (define (iter result rest)
    (if (null? rest) result
	(iter (op result (car rest))
	      (cdr rest))))
  (iter initial sequence))

;; what are the values of:
(newline)
(display (fold-right / 1 (list 1 2 3)) )
(newline)
(display "I thought: 3/2")

(newline)
(display (fold-left / 1 (list 1 2 3)))
(newline)
(display "I thought: 3/2")		; i was wrong! 1/6

(newline)
(display (fold-right list nil (list 1 2 3)))
(newline)
(display "I thought: '(1 (2 (3)))")	; wrong: (1 (2 (3 ())))

(newline)
(display (fold-left list nil (list 1 2 3)))
(newline)
(display "I thought: (3 (2 (1)))")	; wrong: (((() 1) 2) 3)

;; specify a property of op that must be true for fold-right and
;; fold-left to have the same result for a given sequence.
;;
;; the op would have be such that order did not matter - such as + or *
;; (associative?) - wrong :( -- commutative
