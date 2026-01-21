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

:math.even? (λ [n] `(= 0 (% ,n 2)))
:math.odd? (λ [n] `(= 1 (% ,n 2)))

:math.sign (λ [n]
  `(if (> ,n 0) 1
       (< ,n 0) -1
       0))

:math.at-most 'math.min
:math.at-least 'math.max

; aliases for convenience
:π 'math.pi
:√ 'math.sqrt
:math.e '(math.exp 1)
:∞ .inf
:-∞ -.inf

:math.ln 'math.log
:math.log2 (λ [n] `(math.log ,n 2))
:math.log10 (λ [n] `(math.log ,n 10))

  
}
