;; Solve the following "Liars" puzzle (from Phillips 1934):
;; Five schoolgirls sat for an examination. Their parents -- so they
;; thought -- showed an undue degree of interest in the result. They
;; therefore agreed that, in writing home about the examination, each
;; girl should make one true statement and one untrue one. The
;; following are the relevant passages from their letters:

;; * Betty: "Kitty was second in the examination. I was only third."
;; * Ethel: "You'll be glad to hear that I was on top. Joan was second."
;; * Joan: "I was third, and poor old Ethel was bottom."
;; * Kitty: "I came out second. Mary was only fourth."
;; * Mary: "I was fourth. Top place was taken by Betty."

;; What in fact was the order in which the five girls were placed?

;; All this code must be interpreted by our amb-scheme

(define (distinct? items)
  (cond ((null? items) true)
	((null? (cdr items)) true)
	((member (car items) (cdr items)) false)
	(else (distinct? (cdr items)))))

;; This is needed because our amb-scheme doesn't have AND or OR (!)
(define (xor seq)  
  (require (memq true seq))
  (require (memq false seq)))

(define (liars)
  (let ((betty (amb 1 2 3 4 5))
	(ethel (amb 1 2 3 4 5))
	(joan (amb 1 2 3 4 5))
	(kitty (amb 1 2 3 4 5))
	(mary (amb 1 2 3 4 5)))
    (xor (list (= betty 3) (= kitty 2)))
    (xor (list (= ethel 1) (= joan 2)))
    (xor (list (= joan 3) (= ethel 5)))
    (xor (list (= kitty 2) (= mary 4)))
    (xor (list (= mary 4) (= betty 1)))
    (require (distinct? (list betty ethel joan kitty mary)))
    (list (list 'betty betty)
	  (list 'ethel ethel)
	  (list 'joan joan)
	  (list 'kitty kitty)
	  (list 'mary mary))))
