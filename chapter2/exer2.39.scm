(load "sequences.scm")

(define fold-right accumulate)

(define (fold-left op initial sequence)
  (define (iter result rest)
    (if (null? rest) result
	(iter (op result (car rest))
	      (cdr rest))))
  (iter initial sequence))

;; define reverse in terms of fold-right and fold-left
(define (reverse-right sequence)
  (fold-right (lambda (x y) (append y (list x))) nil sequence))

(define (reverse-left sequence)
  (fold-left (lambda (x y) (append (list y) x)) nil sequence))

(newline)
(display 'reverse-right)
(newline)
(display (reverse-right (list 1 2 3 4 5)))

(newline)
(display 'reverse-left)
(newline)
(display (reverse-left (list 1 2 3 4 5)))
