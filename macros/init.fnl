; file for various QOL macros

; TODO: some way to emit a specific function from a macro
;  - static keyword to put a piece of code at the top level?

; PROBLEM: when you pass a literal function there is no function inlining happening
;  - patch fennel compiler to make inline functions (like in C)
; TODO: implement `pattern` for functions that inline like macros instead of like C functions
; TODO: some way to have a macro that's also just a function (hexc-style)


(local these-macros {

; takes code and returns how much time it took to execute
; on computercraft this measures time passed
; on puc lua this measures cpu time used
:timeit (fn [...]
  `(let [start-time# (os.clock)]
     (do ,...)
     (- (os.clock) start-time#)))


})


(require-macros :macros.table)
(table.merge
  (require :macros.table)
  (require :macros.flow)
  (require :macros.math)
  these-macros)
