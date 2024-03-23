let rec map ?(a = []) f l =
  match l with
  | [] -> List.rev a
  | h :: t -> map ~a:(f h :: a) f t
