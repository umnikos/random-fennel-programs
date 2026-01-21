(require-macros :macros)


(class complex [real imag] (set-default self.imag 0))

(fn complex.__tostring [self]
  (case (math.sign self.imag)
    1 (.. self.real :+ self.imag :i)
    -1 (.. self.real :- (- self.imag) :i)
    0 (.. self.real "+0i")))

(fn complex.__add [x y]
  (case (values (classtype x) (classtype y))
    (:number _) (+ (complex x) y)
    (_ :number) (+ x (complex y))
    (:complex :complex) (complex (+ x.real y.real) (+ x.imag y.imag))
    _ (error (.. "unsupported types for addition: " (classtype x) " and " (classtype y)))
))

(fn complex.__sub [x y]
  (case (values (classtype x) (classtype y))
    (:number _) (- (complex x) y)
    (_ :number) (- x (complex y))
    (:complex :complex) (complex (- x.real y.real) (- x.imag y.imag))
    _ (error (.. "unsupported types for subtraction: " (classtype x) " and " (classtype y)))
))

; (a+bi)(c+di) = ac - bd + (bc + ad)i
(fn complex.__mul [x y]
  (case (values (classtype x) (classtype y))
    (:number _) (* (complex x) y)
    (_ :number) (* x (complex y))
    (:complex :complex) (complex
        (- (* x.real y.real) (* x.imag y.imag))
        (+ (* x.real y.imag) (* x.imag y.real)))
    _ (error (.. "unsupported types for multiplication: " (classtype x) " and " (classtype y)))
))

(fn complex.sin [n]
  (complex
    (* (math.sin n.real) (math.cosh n.imag))
    (* (math.cos n.real) (math.sinh n.imag))))

(fn complex.cos [n]
  (complex
    (* (math.cos n.real) (math.cosh n.imag))
    (* -1 (math.sin n.real) (math.sinh n.imag))))

(print (+ 1 (complex 0 1)))
(print (- 1 (complex 0 1)))
(print (* 1 (complex 0 1)))
(print (* (complex 0 1) (complex 0 1)))

; (print (+ 1 (complex 1 0)))
