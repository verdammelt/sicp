;; exercise 3.81
(define (rand-update x)
  (let ((a 13.0) (b 23.0) (m 31.0))
    (modulo (+ (* a x) b) m)))

(define random-init 0)

(define random-numbers
  (cons-stream random-init
	       (stream-map rand-update random-numbers)))

;; write a function that operates upon an input stream of 'generate/'reset requests
;; 'generate == produce new random number
;; 'reset == reset random number generator to specified value
(define (rand command-stream)
  (define (doit n cmd)
    (cond ((eq? cmd 'generate)
	   (rand-update n))
	  (else cmd)))
  (cons-stream random-init
	       (stream-map doit (rand command-stream) command-stream)))




