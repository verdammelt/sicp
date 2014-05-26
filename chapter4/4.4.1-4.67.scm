;; Devise a loop detection system so that infinite loops such as in
;; exercise 4.64 don't happen.

;; The basic idea is to keep some sort of history so that the system
;; won't repeat the same query.

;; I think that the system will need to store (and make available to
;; the pattern-matcher / unifier at each invocation) a list of history
;; objects which includes the current expression being processed and
;; the input frames. Initially they would both be empty. When either
;; the pattern matcher or unifer see that the pattern and input frames
;; it is about to work on is the same as any one in the history list
;; then it knows it has found a loop. Each time the pattern-matcher /
;; unifier completes work on an expression it needs to pop off the
;; history list the items it added. This is to ensure that each set of
;; queries are processed separately - we only want to detect a loop
;; for all processing of a given query, not across sibling queries.
