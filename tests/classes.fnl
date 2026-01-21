(require-macros :macros)

(class square [x])

(fn square.area [self]
  (^ self.x 2))

(local a (square 5))
(print (a:area)) ; 25

(fn square.__tostring [self]
  (.. "(square " self.x ")"))

(print a) ; "(square 5)"

(print (classtype a)) ; square
(print (classtype 5)) ; number
(print (classtype {})) ; table
