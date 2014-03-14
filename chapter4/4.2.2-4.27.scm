;; In our new lazy-evaluated scheme 
(define count 0)
(define (id x)
  (set! count (+ count 1))
  x)

;; Fill in the responses
;; (define w (id (id 10)))
;; ;;; L-Eval input:
;; count
;; ;;; L-Eval value:
;; <response>

;; 1. Because to define w we need to evaluate (id (id 10)). This will
;; cause id to be to be applied to (id 10). That argument will be
;; delayed in apply. Since id simply returns its argument (after the
;; set!) that thunk will be returned and assigned to w.

;; ;;; L-Eval input:
;; w
;; ;;; L-Eval value:
;; <response>

;; 10. Now W will be evaluated - which will force the thunk. Forcing
;; the thunk will cause (id 10) to be evaluated. 10 will be delayed
;; and then a thunk containing 10 will be returned. The driver-loop
;; will force that and we will see '10'.

;; ;;; L-Eval input:
;; count
;; ;;; L-Eval value:
;; <response>

;; 2. Now that id has been fully evaluated twice.
