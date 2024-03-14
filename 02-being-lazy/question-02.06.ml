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

let letter_of_int n =
  Char.chr (Char.code 'A' + n)

let alphanum_of_int n =
  let rec loop k acc =
    if k < 0 then acc
    else
      let digit = letter_of_int (k mod 26) in
      loop (k / 26 - 1) (String.make 1 digit ^ acc)
  in
  loop n ""

let rec labels' n =
  Cons (alphanum_of_int n, fun () -> labels' (n + 1))

let labels = labels' 0
