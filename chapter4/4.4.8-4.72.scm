;; why interleave streams in disjoin and stream-flatmap?

;; you interleave because each stream is potentially infinite. If you
;; didn't interleave you would need to exhaust the first stream before
;; processing the second stream at all.
