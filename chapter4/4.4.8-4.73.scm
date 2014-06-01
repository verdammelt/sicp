;; why does flatten-stream use delay?

;; because without delay you'd have the danger of an infinite loop
;; since the stream can be infinite.
