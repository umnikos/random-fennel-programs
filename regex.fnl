(local {: semimacro
        : literal?
        &as macro-utils} (require :macros.macro-utils))

(local regex {})

(set regex.quote
  (semimacro (fn [s]
    `(string.gsub ,s "([%(%)%.%%%+%-%*%?%[%]%^%$])" "%%%1"))))


(set regex.compose
  (fn compose [...]
    (case (values (select :# ...) ...)
      (0) ""
      (1 s) s
      (2) ((semimacro #`(.. ,$1 ,$2)) ...)
      (_ a b) (if (literal? a)
        (compose (compose a b) (select 3 ...))
        (compose a (compose (select 2 ...)))))))

; FIXME: these don't work with the current compiler for some reason
(set regex.letters :%a)
(set regex.digits :%d)
(set regex.whitespace :%s)

(print (view regex))

regex


