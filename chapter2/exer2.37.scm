(load "sequences.scm")

;; from exer 2.36:
(define (accumulate-n op init seqs)
  (if (null? (car seqs)) nil
      (cons (accumulate op init (map car seqs))
	    (accumulate-n op init (map cdr seqs)))))


;; represent a matrix as a sequence of sequences (rows of matrix)
;; then:

(define (dot-product v w)
  (accumulate + 0 (map * v w)))

;; finish matrix-*-vector, transpose and matrix-*-matrix:

;; returns vector t wher t(i) = SUM(j)(m(i,j)v(j))
(define (matrix-*-vector m v)
  (map (lambda (row) (dot-product row v)) m))

;; returns matrix n where n(i,j) = m(j,i)
(define (transpose m)
  (accumulate-n cons nil m))

;; returns matrix p where p(i,j) = SUM(k)(m(i,k)n(k,j))
(define (matrix-*-matrix m n)
  (let ((cols (transpose n)))
    (map (lambda (row) (matrix-*-vector cols row)) m)))

(define test-matrix (list (list 1 2 3 4) (list 4 5 6 6) (list 6 7 8 9)))
(define test-vector-v (list 1 2 3 4))
(define test-vector-w (list 5 6 7 8))

