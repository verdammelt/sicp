(define inc 1+)

;;; define a method double which applies its argument (a function) twice
(define (double f)
  (lambda (x) (f (f x))))

(newline) (display ((double inc) 0))
(newline) (display ((double inc) 40))

;; what does the following do?
;(((double (double double)) inc) 5)
;; should return 13
;; (double double) is quadruple
;; (double quadruple) is octuple
;; (octuple inc) adds 8
(newline) (display (((double (double double)) inc) 5))
;; i got it wrong!
;; (double quadruple) would be hexuple (16 times)


