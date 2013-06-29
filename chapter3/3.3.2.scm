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

;; exercise 3.23

;; implement a deque which is a queue that allows inserts, retrieval
;; and deletes from both ends. All operations should be O(1). The same
;; structure as a queue cannot be used (because remove-rear would not
;; be O(1).  Need something like a doubly-linked list. Each element is
;; a cons, the cdr points at the next elemnet as usual, the car is a
;; cons of the element and a pointer to the previous element.
(define (front-ptr q) (car q))
(define (rear-ptr q) (cdr q))
(define (element c) (car c))
(define (back-ptr c) (cdr c))
(define (set-front-ptr! q n) (set-car! q n))
(define (set-rear-ptr! q n) (set-cdr! q n))

(define (make-deque) (list '() '()))
(define (empty-deque? q) (null? (front-ptr q)))
(define (front-deque q) 
  (if (empty-deque? q)
      (error "FRONT called on empty deque") 
      (caar (front-ptr q))))
(define (rear-deque q) 
  (if (empty-deque? q) 
      (error "REAR called on empty deque") 
      (caar (rear-ptr q))))
(define (print-deque q)
  (map (lambda (x) (display (car x)) (display " ")) (front-ptr q)))
(define (insert-front-deque! q x)
  (let ((new-pair (cons (cons x '()) '())))
    (if (empty-deque? q)
	(begin (set-front-ptr! q new-pair)
	       (set-rear-ptr! q new-pair))
	(begin (set-cdr! new-pair (front-ptr q))
	       (set-cdr! (car (front-ptr q)) new-pair)
	       (set-front-ptr! q new-pair)))))
(define (insert-rear-deque! q x)
  (let ((new-pair (cons (cons x (rear-ptr q)) '())))
    (if (empty-deque? q)
	(begin (set-front-ptr! q new-pair)
	       (set-rear-ptr! q new-pair))
	(begin (set-cdr! (rear-ptr q) new-pair)
	       (set-rear-ptr! q new-pair)))))

(define q (make-deque))
(insert-front-deque! q 'x)
(insert-front-deque! q 'y)
(insert-front-deque! q 'z)
(insert-rear-deque! q 'a)
(insert-rear-deque! q 'b)
(insert-rear-deque! q 'c)
(display "The DEQUE: \n")
(print-deque q)
(display "\n")

(define (delete-front-deque! q)
  (if (empty-deque? q)
      (error "DELETE-FRONT called on empty deque")
      (set-front-ptr! q (cdr (front-ptr q)))))

(display "delete from front: \n")
(delete-front-deque! q)
(print-deque q)
(display "\n")

(define (delete-rear-deque! q)
  (if (empty-deque? q)
      (error "DELETE-REAR called on empty deque")
      (begin (set-rear-ptr! q (cdar (rear-ptr q)))
	     (set-cdr! (rear-ptr q) '()))))

(display "delete from rear: \n")
(delete-rear-deque! q)
(print-deque q)
(display "\n")


