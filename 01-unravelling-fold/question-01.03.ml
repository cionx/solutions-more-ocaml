let last l =
  match l with
  | [] -> invalid_arg "last: empty list"
  | h :: t -> List.fold_left (fun _ x -> x) h t
