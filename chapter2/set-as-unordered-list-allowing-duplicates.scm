;; exercise 2.60
(define dup-set1 '(a b a c b))
(define dup-set2 '(c b d c d))

(define (element-of-set? x set)
  (cond ((null? set) false)
	((equal? x (car set)) true)
	(else (element-of-set? x (cdr set)))))

(define (adjoin-set x set)
  (cons x set))

(define (intersection-set set1 set2)
  (cond ((or (null? set1) (null? set2)) '())
	((element-of-set? (car set1) set2)
	 (cons (car set1)
	       (intersection-set (cdr set1) set2)))
	(else (intersection-set (cdr set1) set2))))

(define (union-set set1 set2)
  (append set1 set2))

;; element-of-set? has the same efficiency - it is unchanged
;; adjoin-set is a constant operation now (or as good as cons is)
;; intersetction-set can now be worse than before since it might have more to deal with
;; union-set is as efficient as append - does not need to do lookups.
