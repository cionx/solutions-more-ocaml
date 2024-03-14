let total budget expenses =
  List.fold_left (fun acc e -> acc - e) budget expenses
