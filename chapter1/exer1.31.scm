(load-option 'format)

;;; a. write a method product analogous to sum and use it to write
;;; method which approximates PI as:
;;; (/ PI 4) = (/ (* 2 4 4 6 6 8...) (* 3 3 5 5 7 7...))
(define (product term a inc b)
  (if (> a b) 1
      (* (product term (inc a) inc b)
	 (term a))))

(define (pi-approx n)
  (define inc 1+)
  (define (term k) 
    (define (b k) (cond ((even? k) (* 2 (/ k 2)))
			(else (* 2 (/ (- k 1) 2)))))
    (define x (+ 2 (b (inc k))))
    (define y (+ 3 (b k)))
    (/ x y))
  (* 4.0 (product term 0 inc n)))

(newline)
(map (lambda (n) 
       (format #t "(pi-approx ~A) => ~A~%"
	       n (pi-approx n)))
     '(10 100 1000 10000 25000))
 
;;; b. if you wrote a linear recursive product method above - change
;;; it to linera iterative or visa-versa
(define (product-iter term a inc b)
  (define (iter a result)
    (if (> a b) result
	(* (iter (inc a) (* (term a) result)))))
  (iter a 1))

(define (pi-approx-iter n)
  (define inc 1+)
  (define (term k) 
    (define (b k) (cond ((even? k) (* 2 (/ k 2)))
			(else (* 2 (/ (- k 1) 2)))))
    (define x (+ 2 (b (inc k))))
    (define y (+ 3 (b k)))
    (/ x y))
  (* 4.0 (product-iter term 0 inc n)))

;; iterative version can't handle 25000 ?!
(format #t "iterative version")
(newline)
(map (lambda (n) 
       (format #t "(pi-approx-iter ~A) => ~A~%"
	       n (pi-approx-iter n)))
     '(10 100 1000 10000))
