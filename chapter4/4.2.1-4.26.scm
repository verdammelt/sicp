;; Should unless be defined as a special form?

;; Implementing it as a special form could be just as easy as
;; rewriting it to an if (which is already a special form) and then
;; having that be evaluated.
;;
(unless a b c) ==> (if a c b)

;; Is there cases when you would rather have it be a real function?
;; it could be useful to have unless as a real function so you could
;; apply it to some data with someting like map. Perhaps you had data
;; like this:
(set! data '((true fn-a fn-b) (false fn-c fn-d)))

;; maybe this is data form a user form showing what they chose and
;; then the functions to depending upon their choices. 
(map unless data) 
;; would return a list of functions to apply

