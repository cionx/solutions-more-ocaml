let time f x =
  let t1 = Sys.time () in
  let _ = f x in
  let t2 = Sys.time () in
  t2 -. t1

(** Question 1.2. *)

let length l =
  List.fold_left (fun acc _ -> acc + 1) 0 l

let gen_list n =
  List.init n Fun.id

let test_length n =
  let l = gen_list n in
  let t_std = time List.length l in
  let t_own = time length l in
  Format.printf "std: %g\nown: %g\n" t_std t_own

(** Question 1.5 *)

let any l = List.fold_left ( || ) false l

let exists p l =
  any (List.map p l)

let mem x l =
  exists (( = ) x) l

(* How to measure the running time of List.mem? *)
