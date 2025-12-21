(require-macros :macros)


; generates the primes from 2 to n
(<<-
  (λ primes [n])
  (do
    (local primes [])
    (var primes-count 0))
  (lastly primes)
  (for [c 2 n])
  (do
    (var is-prime true))
  (lastly (when is-prime
    (table.insert primes c)
    (inc primes-count)))
  (each [_ p (ipairs primes) &while (and is-prime (<= (* p p) c))])
  (if (= 0 (% c p))
  (set is-prime false))
)

