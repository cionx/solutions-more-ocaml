(** From the textbook. *)

type 'a tree = Lf | Br of 'a * 'a tree * 'a tree

let rec fold_tree f e t =
  match t with
  | Lf -> e
  | Br (x, l, r) -> f x (fold_tree f e l) (fold_tree f e r)



(** For this exercise. *)

let depth t =
  fold_tree (fun x l r -> 1 + max l r) 0 t
