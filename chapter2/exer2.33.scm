(load "sequences.scm")

;; Finish these definitions
;; (define (map p sequence)
;;   (accumulate (lambda (x y) <??>) nil sequence))
;; (define (append seq1 seq2)
;;   (accumulate cons <??> <??>))
;; (define (length sequence)
;;   (accumulate <??> 0 sequence))

(define (map p sequence)
  (accumulate (lambda (x y) (cons (p x) y)) nil sequence))

(define (append seq1 seq2)
  (accumulate cons seq2 seq1))

(define (length sequence)
  (accumulate (lambda (x y) (+ y 1)) 0 sequence))

