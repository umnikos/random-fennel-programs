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

:set-default (fn [v ...]
  `(set ,v ,(default v ...)))

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
  
}
