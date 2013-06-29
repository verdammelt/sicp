;; exer 3.21
;; the Lisp printer is printing the cons that defines the queue.
;; the car of it is the entire queue, the cdr is the final cell
;; of the queue - thus Ben's confusion.
;; a procedure like this:
(define (print-queue q)
  (front-ptr q))
;; would do the trick to keep Ben from being confused.

;; exer 3.22
(define (make-queue)
  (let ((front-ptr '())
	(rear-ptr '()))
    (define (dispatch m)
      (cond ((eq? m 'empty?) (null? front-ptr))
	    ((eq? m 'front) (if (dispatch 'empty?) 
				(error "FRONT called on empty queue")
				(car front-ptr)))
	    ((eq? m 'insert!) (lambda (x) 
				(cond ((dispatch 'empty?)
				       (let ((new-pair (cons x '())))
					 (set! front-ptr new-pair)
					 (set! rear-ptr new-pair)))
				      (else (set-cdr! rear-ptr x)
					    (set! rear-ptr x)))))
	    ((eq? m 'delete!) (cond ((dispatch 'empty?)
				     (error "DELETE on empty queue"))
				    (else (set! front-ptr (cdr front-ptr)))))
	    ((eq? m 'print) (cons front-ptr rear-ptr))
	    (else (error "Unknown command"))))
    dispatch))




