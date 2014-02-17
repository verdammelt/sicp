;; Given the following procedure:
;; (lambda <vars>
;;   (define u <e1>)
;;   (define v <e2>)
;;   <e3>)

;; The first 'scan out' algorithm:
;; (lambda <vars>
;;   (let ((u '*unassigned*)
;; 	(v '*unassigned*))
;;     (set! u <e1>)
;;     (set! v <e2>)
;;     <e3>))

;; an alternative 'scan out' algorithm:
;; (lambda <vars>
;;   (let ((u '*unassigned*)
;; 	(v '*unassigned*))
;;     (let ((a <e1>)
;; 	  (b <e2>))
;;       (set! u a)
;;       (set! v b))
;;     <e3>))

;; a. Will this procedure work with the alternative algorithm?
;; (define (solve f y0 dt)
;;   (define y (integral (delay dy) y0 dt))
;;   (define dy (stream-map f y))
;;   y)
;;
;; This end up something like:
;; (lambda (solve f y0 dt)
;;   (let ((y '*unassigned*)
;; 	(dy '*unassigned*))
;;     (let ((gensym-1 (integral (delay dy) y0 dt))
;; 	  (gensym-2 (stream-map f y)))
;;       (set! y gensym-1)
;;       (set! dy gensym-2))
;;     y))
;;
;; This won't work because in setting gensym-2 the last parameter of
;; stream-map will be '*unassigned* because that is what y is bound to

;; b. Will it work with the first algorithm?
;; 
;; It would end up with something like:
(lambda (solve f y0 dt)
  (let ((y '*unassigned*)
	(dy '*unassigned*))
    (set! y (integral (delay dy) y0 dt))
    (set! dy (stream-map f y))
    y))
;;
;; This will work because when dy is bound y is already bound
;; properly. The binding of y contains reference to dy, but it is
;; inside the delay special form so dy there is not actually evaluated
;; until later after dy is bound.

