let rec fold_left f a l =
  match l with
  | [] -> a
  | h :: t -> fold_left f (f a h) t

let rec fold_right f l a =
  match l with
  | [] -> a
  | h :: t -> f h (fold_right f t a)

let all l = fold_left ( && ) true l

let any l = fold_left ( || ) false l

let setify l =
  fold_left (fun a e -> if List.mem e a then a else e :: a) [] l

let map f l =
  fold_right (fun e a -> f e :: a) l []

let copy l =
  fold_right (fun e a -> e :: a) l []

let append x y =
  fold_right (fun e a -> e :: a) x y

let split l =
  fold_right (fun (x, y) (xs, ys) -> (x :: xs, y :: ys)) l ([], [])



type 'a tree = Lf | Br of 'a * 'a tree * 'a tree

let rec fold_tree f e t =
  match t with
  | Lf -> e
  | Br (x, l, r) -> f x (fold_tree f e l) (fold_tree f e r)

let tree_size t =
  fold_tree (fun _ l r -> 1 + l + r) 0 t

let tree_sum t =
  fold_tree (fun x l r -> x + l + r) 0 t

let tree_preorder t =
  fold_tree (fun x l r -> [x] @ l @ r) [] t

let tree_inorder t =
  fold_tree (fun x l r -> l @ [x] @ r) [] t

let tree_postorder t =
  fold_tree (fun x l r -> l @ r @ [x]) [] t
