(load "deriv.scm")

;; implement the derivation rule:
;; (d(u**n)/dx) == nu^(n-1)(du/dx)
;;

;; test: (d(x^3)/dx) == 3x^2
(equal? (deriv '(** x 3) 'x)
	'(* 3 (** x 2)))


