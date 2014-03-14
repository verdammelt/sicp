;; Q: To write a function to geneate ALL pythagorean triples with no
;; upper bound. Why isn't it enough to take this:
(define (a-pythagorean-triple-between low high)
  (let ((i (an-integer-between low high)))
    (let ((j (an-integer-between i high)))
      (let ((k (an-integer-between j high)))
	(require (= (+ (* i i) (* j j)) (* k k)))
	(list i j k)))))

;; and replace an-integer-between with an-integer-starting-from ? 

;; (NOTE: I couldn't figure this out until I saw the below answer to
;; how to write the actual procedure - a good case where the solution
;; in code made the problem it was solving more obvious)
;; A: because k is the item that will be changing first when it the
;; require fails, only after exhausing ALL POSSIBLE k will it try
;; anothr j etc. This will take infinite time.

;; write a procedure that will actually do the right thing.

;; http://community.schemewiki.org/?sicp-ex-4.36
(define (a-pythagorean-triple-from low)
  (let ((k (an-integer-starting-from low)))
    (let ((j (an-integer-between low k)))
      (let ((i (an-integer-between j k)))
	(require (= (+ (* i i) (* j j)) (* k k)))
	(list i j k)))))

