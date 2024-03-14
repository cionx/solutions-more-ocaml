(** From the textbook. *)

type 'a lazylist = Cons of 'a * (unit -> 'a lazylist)

let lhd (Cons (h, _)) = h
let ltl (Cons (_, tf)) = tf ()

let rec ltake l n =
  if n <= 0 then [] else (lhd l) :: ltake (ltl l) (n - 1)

let rec ldrop l n =
  if n <= 0 then l else ldrop (ltl l) (n - 1)

let rec lseq n =
  Cons (n, fun () -> lseq (n + 1))

let nats = lseq 0



(** For this exercise. *)

let rec fib' (a, b) =
  Cons (a, fun () -> fib' (b, a + b))

let fib = fib' (0, 1)
