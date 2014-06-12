;; Design a machine to compute square roots using Newton's method, as
;; described in section 1.1.7:

;; (define (sqrt x)
;;   (define (good-enough? guess)
;;     (< (abs (- (square guess) x)) 0.001))
;;   (define (improve guess)
;;     (average guess (/ x guess)))
;;   (define (sqrt-iter guess)
;;     (if (good-enough? guess)
;;         guess
;;         (sqrt-iter (improve guess))))
;;   (sqrt-iter 1.0))

;; Begin by assuming that good-enough? and improve operations are
;; available as primitives. Then show how to expand these in terms of
;; arithmetic operations. Describe each version of the sqrt machine
;; design by drawing a data-path diagram and writing a controller
;; definition in the register-machine language.

;; (going to skip the data path diagrams - mjs)

;; 1. assuming that good-enough? and improve are primtives

(controller
 (assign x (op read))
 (assign guess (const 1.0))

 test-good
 (test (op good-enough?) (reg guess) (reg x))
 (branch (label done))
 (assign t (op improve) (reg guess) (reg x))
 (assign guess (reg t))
 (goto test-good)
 done

 (perform (op print) (reg guess))
 )

;; 2. inline improve

(controller
 (assign x (op read))
 (assign guess (const 1.0))

 test-good
 (test (op good-enough?) (reg guess) (reg x))
 (branch (label done))

 ;; improve procedure
 (assign div (op /) (reg x) (reg guess))
 (assign avg (op average) (reg guess) (reg div))

 (assign t (reg avg))
 (assign guess (reg t))
 (goto test-good)
 done

 (perform (op print) (reg guess))
 )

;; 2a inline average
(controller
 (assign x (op read))
 (assign guess (const 1.0))

 test-good
 (test (op good-enough?) (reg guess) (reg x))
 (branch (label done))

 ;; improve procedure
 (assign div (op /) (reg x) (reg guess))

 ;; average procedure
 (assign sum (op +) (reg guess) (reg div))
 (assign avg (op /) (reg sum) (const 2))

 (assign t (reg avg))
 (assign guess (reg t))
 (goto test-good)
 done

 (perform (op print) (reg guess))
 )

3. inline good-enough?
(controller
 (assign x (op read))
 (assign guess (const 1.0))

 test-good
 
 ;; good-enough? procedure
 (assign square (op *) (reg guess) (reg guess))
 (assign diff (op -) (reg square) (reg x))
 (test (op <) (reg diff) (const 0))
 (branch test-abs-neg)
 test-abs-pos
 (assign abs (reg diff))
 test-abs-neg
 (assign abs (op *) (reg diff) (const -1))
 (test (op <) (reg abs) (const 0.001))

 (branch (label done))

 ;; improve procedure
 (assign div (op /) (reg x) (reg guess))
 ;; average procedure
 (assign sum (op +) (reg guess) (reg div))
 (assign avg (op /) (reg sum) (const 2))

 (assign t (reg avg))
 (assign guess (reg t))
 (goto test-good)
 done

 (perform (op print) (reg guess))
 )
