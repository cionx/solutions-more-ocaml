let join_left sep strs =
  match strs with
  | [] -> ""
  | str :: strs' ->
    List.fold_left (fun acc s -> acc ^ sep ^ s) str strs'

let join_right sep strs =
  match strs with
  | [] -> ""
  | str :: strs' ->
    str ^ List.fold_right (fun s acc -> sep ^ s ^ acc) strs' ""



let time f x =
  let t1 = Sys.time () in
  let _ = f x in
  let t2 = Sys.time () in
  t2 -. t1

let strs n = List.init n (fun k -> "a")
let concat_left = join_left ""
let concat_right = join_right ""
