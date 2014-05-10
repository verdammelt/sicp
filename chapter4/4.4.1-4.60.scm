;; By giving the query
;;     (lives-near ?person (Hacker Alyssa P))
;; Alyssa P. Hacker is able to find people who live near her, with
;; whom she can ride to work. On the other hand, when she tries to
;; find all pairs of people who live near each other by querying
;;     (lives-near ?person-1 ?person-2)
;; she notices that each pair of people who live near each other is
;; listed twice; for example,
;;     (lives-near (Hacker Alyssa P) (Fect Cy D))
;;     (lives-near (Fect Cy D) (Hacker Alyssa P))

;; Why does this happen? 

;;; This happens because first the query engine tries Alyssa and finds
;;; that match and then later tries Cy and finds that match as well.

;; Is there a way to find a list of people who live near each other,
;; in which each pair appears only once?

;;; I do not believe there is a way. Even if you did (and (lives-near
;;; ?p1 ?p2) (lives-near ?p2 ?p1)) you'd still get a pair.

;; Explain.


;;; NOTE: http://community.schemewiki.org/?sicp-ex-4.60 gives an
;;; interesting way to fix the pairing problem. By asserting that the
;;; names need to be in an order we'd only get one set, not both since
;;; they could not both fulfill the query.
