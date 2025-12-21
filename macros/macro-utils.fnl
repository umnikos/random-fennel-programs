(require-macros :macros.table)

; shallow copy
(fn copy [t]
  (let [out []]
    (each [_ v (ipairs t)] (table.insert out v))
    (setmetatable out (getmetatable t))))

; expands macros recursively
; (unlike macroexpand which only expands the top level macros)
(fn expand-macros [arg]
  (local ast (macroexpand arg))
  (if (list? ast) `(,(unpack (icollect [_ v (ipairs ast)] (expand-macros v))))
      (sequence? ast) `[,(unpack (icollect [_ v (ipairs ast)] (expand-macros v)))]
      (table? ast) (collect [k v (pairs ast)] (values (expand-macros k) (expand-macros v)))
      ast))

; returns if the argument is a comptime literal and not an ast of some sort
(fn literal? [a*]
  (local a (macroexpand a*))
  (if (list? a) false
      (sym? a) false
      (varg? a) false
      (comment? a) false
      (sequence? a) false ; FIXME
      (table? a) false ; FIXME
      true))

; same as `compile` but does macroexpansion before compilation
(fn compiled [& args]
  (let [expanded-args (icollect [_ v (ipairs args)] (expand-macros v))
        ast `(do ,(unpack expanded-args))]
      (compile ast)))

; evals an ast
(fn eval [ast]
  ((load (compile ast))))

; takes a macro function and returns another macro function
; the resulting macro function executes the resulting body if all arguments are literals
(fn semimacro [f]
  (fn [& args]
    (if (table.all? literal? args)
      (eval (f (unpack args)))
      (f (unpack args))
    )
  )
)

{
  : copy
  : expand-macros
  : literal?
  : compiled
  : eval
  : semimacro
}
