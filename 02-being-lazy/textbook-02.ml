type 'a lazylist = Cons of 'a * (unit -> 'a lazylist)

let rec lseq n =
  Cons (n, fun () -> lseq (n + 1))

let nats = lseq 0 (* Not in the textbook. *)

let lhd (Cons (n, _)) = n
let ltl (Cons (_, tf)) = tf ()

let rec ltake ll n =
  if n = 0 then [] else (lhd ll) :: ltake (ltl ll) (n - 1)

let rec ldrop ll n =
  if n = 0 then ll else ldrop (ltl ll) (n - 1)

let rec lmap f ll =
  Cons (f (lhd ll), fun () -> lmap f (ltl ll))

let rec lfilter p ll =
  let h = lhd ll in
  if p h
  then Cons (h, fun () -> lfilter p (ltl ll))
  else lfilter p (ltl ll)

let rec mkprimes ll =
  let p = lhd ll in
  Cons (p, fun () -> mkprimes (lfilter (fun x -> x mod p <> 0) (ltl ll)))

let primes =
  mkprimes (lseq 2)

let rec interleave ll1 ll2 =
  Cons (lhd ll1, fun () -> interleave ll2 (ltl ll1))
