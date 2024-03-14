(** From the textbook. *)

let any l = List.fold_left ( || ) false l



(** For this exercise. *)

(** [exists p l] is wheter [p x] for some element [x] of [l]. *)
let exists p l =
  any (List.map p l)

let mem x l =
  exists (( = ) x) l
