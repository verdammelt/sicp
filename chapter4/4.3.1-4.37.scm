;; Q: is this version from Ben more efficient with respect to the
;; number of items searched?
(define (a-pythagorean-triple-between low high)
  (let ((i (an-integer-between low high))
	(hsq (* high high)))
    (let ((j (an-integer-between i high)))
      (let ((ksq (+ (* i i) (* j j))))
	(require (>= hsq ksq))
	(let ((k (sqrt ksq)))
	  (require (integer? k))
	  (list i j k))))))

;; compare with this version:
(define (a-pythagorean-triple-between low high)
  (let ((i (an-integer-between low high)))
    (let ((j (an-integer-between i high)))
      (let ((k (an-integer-between j high)))
	(require (= (+ (* i i) (* j j)) (* k k)))
	(list i j k)))))

;; A: yes, more efficient because instead of 3 amb items you only have
;; 2. The third can be calculated from the other two.
