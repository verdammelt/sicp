;; What is the purpose of the let bindings in the procedures
;; add-assertion! and addrule! ? What would be wrong with the
;; following implementation of add-assertion! ? Hint: Recall the
;; definition of the infinite stream of ones in section 3.5.2: (define
;; ones (cons-stream 1 ones)).

(define (add-assertion! assertion)
  (store-assertion-in-index assertion)
  (set! THE-ASSERTIONS
	(cons-stream assertion THE-ASSERTIONS))
  'ok)

;; the reason for the let is to ensure that THE-ASSERTIONS is
;; evaluated. cons-stream does not evaluate its second arguemnt

