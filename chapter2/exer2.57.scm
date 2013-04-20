(load "deriv.scm")

(equal? (deriv '(* x y (+ x 3)) x)
	)

;; dc/dx = 0
;; dx/dx = 1
;; d(u+v)/dx = du/dx = dv/dx
;; d(uv)/dx = u(dv/dx) + v(du/dx)


