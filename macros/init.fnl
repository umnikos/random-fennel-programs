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


(local these-macros {
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

; executes macro code in-line and returns the result
; the name comes from verilog's generate keyword
:generate eval

; like do but does the first action last
; made to be combined with <<-
:lastly (fn [f & args]
  (local actions (copy args))
  (table.insert actions f)
  `(do ,(unpack actions)))

; accepts a let-style bindings list instead of a condition
; the last variable in the bindings list is treated as the condition
; example:
;   (if-let
;     [a 10 b nil] b
;     [c (+ a 10)] c
;     100)
;   ->  20
:if-let (fn if-let [bindings t ...]
  (local n (length bindings))
  (assert-compile (= 0 (% n 2)) "uneven number of elements in let bindings" bindings)
  (assert-compile t "t is nil" t)
  (local last-symbol (. bindings (- n 1)))
  `(let ,bindings
    (if ,last-symbol
      ,t
      ,(case (select :# ...)
         0 'nil
         1 ...
         _ (if-let ...)))))

; takes code and returns how much time it took to execute
; on computercraft this measures time passed
; on puc lua this measures cpu time used
:timeit (fn [...]
  `(let [start-time# (os.clock)]
     (do ,...)
     (- (os.clock) start-time#)))

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


})


(local table-macros (require :macros.table))
(require-macros :macros.table)

(table.merge these-macros table-macros)
