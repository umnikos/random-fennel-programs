; file for various QOL macros

; TODO: some way to emit a specific function from a macro
;  - static keyword to put a piece of code at the top level?

; PROBLEM: when you pass a literal function there is no function inlining happening
;  - patch fennel compiler to make inline functions (like in C)
; TODO: implement `pattern` for functions that inline like macros instead of like C functions
; TODO: some way to have a macro that's also just a function (hexc-style)

(local {: copy
        : expand-macros
        : eval
       } (require :macros.macro-utils))



{
; returns the first non-nil argument
; basically has the same job as `or` except it doesn't get fooled by `false`
:default (fn default [...]
  (case (values (select :# ...) ...)
    (0) 'nil
    (1 v) v
    (_ v) `(let [val# ,v]
            (if (not= nil val#)
              val#
              ,(default (select 2 ...))))))

; executes macro code in-line
; the name comes from verilog's generate keyword
:generate (fn [& body]
  (eval `(do ,(unpack body))))

; like do but does the first action last
; made to be combined with <<-
:lastly (fn [f & args]
  (local actions (copy args))
  (table.insert actions f)
  `(do ,(unpack actions)))


; returns the first item in the array that matches the predicate, if any
:table.first (λ first [pred arr]
  `(let [arr# ,arr]
      (var found# nil)
      (each [_# item# (ipairs arr#) &until (not= nil found#)]
        (if (,pred item#)
          (set found# item#)))
      found#))

; returns any element from the table that matches the predicate
:table.any (fn any [pred arr]
  `(let [arr# ,arr]
      (var found# nil)
      (each [_# item# (pairs arr#) &until (not= nil found#)]
        (if (,pred item#)
          (set found# item#)))
      found#))

; returns if any element from the table matches the predicate
:table.any? (fn any? [pred arr]
  `(not= nil ,(any pred arr)))

; returns if all elements from the table match the predicate
:table.all? (fn [pred arr]
  `(= nil ,(any `#(not (,pred $...)) arr)))

; returns if the element is contained in the table
:table.in? (fn [el arr]
  (any? `#(= $ ,el) arr))

; counts how many items in the table match the predicate function
:table.count (fn [pred arr]
  `(accumulate [sum# 0 _# item# (pairs ,arr)]
     (+ sum#
        (if (,pred item#) 1 0))))

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

; you know what map is
:table.map (fn [f arr]
  `(collect [_# val# (pairs ,arr)]
     (,f val#)))

; you also know what filter is
:table.filter (fn [f arr]
  `(collect [_# val# (pairs ,arr)]
     (if (,f val#) val#)))

; produces a new array that's a concatenation of all of the given ones
; with just a single array passed in it's equivalent to a shallow copy
:table.concat (fn concat [& arrs]
  `(do
    (local res# [])
    (do ,(unpack (icollect [_ arr (ipairs arrs)]
      `(each [_# v# (ipairs ,arr)]
        (table.insert res# v#)))))
    res#))

; makes a shallow copy of an array
:table.copy (fn [arr]
  (concat arr))

}
