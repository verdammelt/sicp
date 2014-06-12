;; The following register-machine code is ambiguous, because the label
;; here is defined more than once:

;; start
;;   (goto (label here))
;; here
;;   (assign a (const 3))
;;   (goto (label there))
;; here
;;   (assign a (const 4))
;;   (goto (label there))
;; there

;; With the simulator as written, what will the contents of register a
;; be when control reaches there? 

;; It will be 3 because looking up labels is done with assoc which
;; returns the first element with matching value.


;; Modify the extract-labels procedure so that the assembler will
;; signal an error if the same label name is used to indicate two
;; different locations.

(define (extract-labels text receive)
  (if (null? text)
      (receive '() '())
      (extract-labels (cdr text)
       (lambda (insts labels)
         (let ((next-inst (car text)))
           (if (symbol? next-inst)
	       (if (assoc next-inst labels)
		   (error "Duplicate label -- ASSEMBLE" next-inst)
		   (receive insts
			    (cons (make-label-entry next-inst
						    insts)
				  labels)))
               (receive (cons (make-instruction next-inst)
                              insts)
                        labels)))))))


