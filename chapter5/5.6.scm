;; Ben Bitdiddle observes that the Fibonacci machine's controller
;; sequence has an extra save and an extra restore, which can be
;; removed to make a faster machine. Where are these instructions?

;; In the section starting with label afterfib-n-1 there is a (restore
;; continue) then 2 instructions later (save continue). But the
;; intervening instruction does not affect continue at all

