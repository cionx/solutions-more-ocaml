let length l =
  List.fold_left (fun acc _ -> acc + 1) 0 l
