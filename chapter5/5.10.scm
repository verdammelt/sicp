;; Design a new syntax for register-machine instructions and modify
;; the simulator to use your new syntax. Can you implement your new
;; syntax without changing any part of the simulator except the syntax
;; procedures in this section?

;; as an example - instead of (assign x (op +) (reg a) (reg b)) I want
;; the syntax: (assign x (apply + (reg a) (reg b)))

(define (operation-exp? exp)
  (tagged-list? exp 'apply))
(define (operation-exp-op exp)
  (cadr exp))
(define (operation-exp-operands exp)
  (cddr exp))

;; this syntax change didn't have to change any part of the simulator.
