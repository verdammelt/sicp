;; redefine the frames from being two lists (vars and vals) to a list
;; of pairs, each variale and its value

(define (make-frame variables values)
  (define (make-frame-helper variables values accum)
    (if (null? variables) accum
	(make-frame-helper (cdr variables) 
			   (cdr values) 
			   (cons (cons (car variables) (car values)) 
				 accum))))
  (make-frame-helper variables values (list (list))))

(define (frame-variables frame) (map car (car frame)))
(define (frame-values frame) (map cdr (car frame)))

(define (add-binding-to-frame! var val frame)
  (set-car! frame (cons (cons var val) (car frame))))

