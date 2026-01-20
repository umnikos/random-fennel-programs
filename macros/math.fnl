(local {: default} (require :macros.flow))

{

; increments a variable, either by 1 or by the supplied value
; assumes the variable is 0 if it's nil
:inc (fn [v ?val]
  (local val (or ?val '1))
  `(set ,v (+ ,(default v '0) ,val)))

; decrements a variable, either by 1 or by the supplied value
; assumes the variable is 0 if it's nil
:dec (fn [v ?val]
  (local val (or ?val '1))
  `(set ,v (- ,(default v '0) ,val)))

; takes a table and returns the sum of the elements
:math.sum (fn [arr]
  `(accumulate [sum# 0 _# val# (pairs ,arr)]
    (+ sum# val#)))

; takes a table and returns the product of the elements
:math.prod (fn [arr]
  `(accumulate [prod# 1 _# val# (pairs ,arr)]
    (* prod# val#)))

:math.even? (fn [n] `(= 0 (% ,n 2)))
:math.odd? (fn [n] `(= 1 (% ,n 2)))

; aliases for convenience
:π 'math.pi
:√ 'math.sqrt
:math.e '(math.exp 1)
:math.ln 'math.log

  
}
