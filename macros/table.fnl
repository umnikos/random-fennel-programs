{
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

; merges key-value tables into one
; where the last table has precedence
:table.merge (fn [& arrs]
  `(do
    (local res# {})
    (do ,(unpack (icollect [_ arr (ipairs arrs)]
      `(each [k# v# (pairs ,arr)]
        (tset res# k# v#)))))
    res#))

; makes a shallow copy of an array
:table.copy (fn [arr]
  (concat arr))

:table.keys (fn [arr]
  `(icollect [k# _# (pairs ,arr)] k#))

:table.vals (fn [arr]
  `(icollect [_# v# (pairs ,arr)] v#))
}
