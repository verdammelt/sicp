;; Order of evaluation for arguments is right to left. 

;; To change this we'd change construct-arglist to not reverse the
;; operand-codes, use a differnt means of creating the arglist; cons
;; will not work. Also the primitives for calling a fucntion on a list
;; of arguments will need to change

;; The building up of the operands in reverse order is very simple
;; since it only needs to start with a list of the right-most argument
;; and cons on the next left argument. Consing to the end of a list is
;; less efficient.

;; UPDATE after reading http://community.schemewiki.org/?sicp-ex-5.36.
;; that answer points out that the creating arglist could be reversed
;; with an instruction. So instead of doing the work during
;; compilation the work would be done during execution.
