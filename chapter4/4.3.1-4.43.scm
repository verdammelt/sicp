;; Use amb to solve:

;; Mary Ann Moore's father has a yacht and so has each of his four
;; friends: Colonel Downing, Mr. Hall, Sir Barnacle Hood, and Dr.
;; Parker. Each of the five also has one daughter and each has named
;; his yacht after a daughter of one of the others. Sir Barnacle's
;; yacht is the Gabrielle, Mr. Moore owns the Lorna; Mr. Hall the
;; Rosalind. The Melissa, owned by Colonel Downing, is named after Sir
;; Barnacle's daughter. Gabrielle's father owns the yacht that is
;; named after Dr. Parker's daughter. Who is Lorna's father?

;; Daughters:
;; Mary Ann - Moore
;; Gabrielle
;; Lorna
;; Rosalind
;; Melissa - Hood

;; Fathers:
;; Moore
;; Downing
;; Hall
;; Hood
;; Parker

;; Yachts:
;; Gabriella - Hood
;; Lorna - Moore
;; Rosalind - Hall
;; Melissa - Downing
;; <Parker's Daughter> - <Gabrielles Father>

(define (require p) (if (not p) (amb)))

(define (distinct? items)
  (cond ((null? items) true)
	((null? (cdr items)) true)
	((member (car items) (cdr items)) false)
	(else (distinct? (cdr items)))))

;; solution stolen from http://community.schemewiki.org/?sicp-ex-4.43
(define (fathers-daughters)
  (let ((moore 'maryann)
	(hood 'melissa)
	(downing (amb 'gabriella 'lorna 'rosalind))
	(hall (amb 'gabriella 'lorna))
	(parker (amb 'lorna 'rosalind)))
    (require (cond ((eq? downing 'gabriella) (eq? parker 'melissa))
		   ((eq? hall 'gabriella) (eq? parker 'rosalind))
		   (else false)))
    (require (distinct? (list moore hood downing hall parker)))
    (list (list 'moore moore)
	  (list 'hood hood)
	  (list 'downing downing)
	  (list 'hall hall)
	  (list 'parker parker))
    ))

;; lorna's father is downing

