(local {: semimacro &as macro-utils} (require :macros.macro-utils))

(local regex {})

(set regex.quote
  (semimacro (fn [s]
    `(string.gsub ,s "([%(%)%.%%%+%-%*%?%[%]%^%$])" "%%%1"))))


regex


