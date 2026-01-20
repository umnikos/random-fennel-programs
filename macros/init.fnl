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


:class (λ [name fields ...]
  (import-macros {: default} :macros.flow)
  (assert-compile (sym? name) "name should be a symbol" name)
  (assert-compile (sequence? fields))

  (local fields-without-first
    (fcollect [i 2 (length fields)] (. fields i)))
  
  (local data-setting
    (collect [_ v (ipairs fields-without-first)] (values (tostring v) v)))

  `(local ,name (setmetatable {} {:__call (fn [class# ,(unpack fields-without-first)]
     (local ,(. fields 1) (setmetatable ,data-setting {:__index class#}))
     (do ,...)
     ,(. fields 1)
  )}))
  
)


})


(require-macros :macros.table)
(table.merge
  (require :macros.table)
  (require :macros.flow)
  (require :macros.math)
  these-macros)
