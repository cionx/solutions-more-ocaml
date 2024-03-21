(** From the textbook. *)

let white_terminating_codes =
  [|[0; 0; 1; 1; 0; 1; 0; 1];
    [0; 0; 0; 1; 1; 1];
    [0; 1; 1; 1];
    [1; 0; 0; 0];
    [1; 0; 1; 1];
    [1; 1; 0; 0];
    [1; 1; 1; 0];
    [1; 1; 1; 1];
    [1; 0; 0; 1; 1];
    [1; 0; 1; 0; 0];
    [0; 0; 1; 1; 1];
    [0; 1; 0; 0; 0];
    [0; 0; 1; 0; 0; 0];
    [0; 0; 0; 0; 1; 1];
    [1; 1; 0; 1; 0; 0];
    [1; 1; 0; 1; 0; 1];
    [1; 0; 1; 0; 1; 0];
    [1; 0; 1; 0; 1; 1];
    [0; 1; 0; 0; 1; 1; 1];
    [0; 0; 0; 1; 1; 0; 0];
    [0; 0; 0; 1; 0; 0; 0];
    [0; 0; 1; 0; 1; 1; 1];
    [0; 0; 0; 0; 0; 1; 1];
    [0; 0; 0; 0; 1; 0; 0];
    [0; 1; 0; 1; 0; 0; 0];
    [0; 1; 0; 1; 0; 1; 1];
    [0; 0; 1; 0; 0; 1; 1];
    [0; 1; 0; 0; 1; 0; 0];
    [0; 0; 1; 1; 0; 0; 0];
    [0; 0; 0; 0; 0; 0; 1; 0];
    [0; 0; 0; 0; 0; 0; 1; 1];
    [0; 0; 0; 1; 1; 0; 1; 0];
    [0; 0; 0; 1; 1; 0; 1; 1];
    [0; 0; 0; 1; 0; 0; 1; 0];
    [0; 0; 0; 1; 0; 0; 1; 1];
    [0; 0; 0; 1; 0; 1; 0; 0];
    [0; 0; 0; 1; 0; 1; 0; 1];
    [0; 0; 0; 1; 0; 1; 1; 0];
    [0; 0; 0; 1; 0; 1; 1; 1];
    [0; 0; 1; 0; 1; 0; 0; 0];
    [0; 0; 1; 0; 1; 0; 0; 1];
    [0; 0; 1; 0; 1; 0; 1; 0];
    [0; 0; 1; 0; 1; 0; 1; 1];
    [0; 0; 1; 0; 1; 1; 0; 0];
    [0; 0; 1; 0; 1; 1; 0; 1];
    [0; 0; 0; 0; 0; 1; 0; 0];
    [0; 0; 0; 0; 0; 1; 0; 1];
    [0; 0; 0; 0; 1; 0; 1; 0];
    [0; 0; 0; 0; 1; 0; 1; 1];
    [0; 1; 0; 1; 0; 0; 1; 0];
    [0; 1; 0; 1; 0; 0; 1; 1];
    [0; 1; 0; 1; 0; 1; 0; 0];
    [0; 1; 0; 1; 0; 1; 0; 1];
    [0; 0; 1; 0; 0; 1; 0; 0];
    [0; 0; 1; 0; 0; 1; 0; 1];
    [0; 1; 0; 1; 1; 0; 0; 0];
    [0; 1; 0; 1; 1; 0; 0; 1];
    [0; 1; 0; 1; 1; 0; 1; 0];
    [0; 1; 0; 1; 1; 0; 1; 1];
    [0; 1; 0; 0; 1; 0; 1; 0];
    [0; 1; 0; 0; 1; 0; 1; 1];
    [0; 0; 1; 1; 0; 0; 1; 0];
    [0; 0; 1; 1; 0; 0; 1; 1];
    [0; 0; 1; 1; 0; 1; 0; 0]|]

let black_terminating_codes =
  [|[0; 0; 0; 0; 1; 1; 0; 1; 1; 1];
    [0; 1; 0];
    [1; 1];
    [1; 0];
    [0; 1; 1];
    [0; 0; 1; 1];
    [0; 0; 1; 0];
    [0; 0; 0; 1; 1];
    [0; 0; 0; 1; 0; 1];
    [0; 0; 0; 1; 0; 0];
    [0; 0; 0; 0; 1; 0; 0];
    [0; 0; 0; 0; 1; 0; 1];
    [0; 0; 0; 0; 1; 1; 1];
    [0; 0; 0; 0; 0; 1; 0; 0];
    [0; 0; 0; 0; 0; 1; 1; 1];
    [0; 0; 0; 0; 1; 1; 0; 0; 0];
    [0; 0; 0; 0; 0; 1; 0; 1; 1; 1];
    [0; 0; 0; 0; 0; 1; 1; 0; 0; 0];
    [0; 0; 0; 0; 0; 0; 1; 0; 0; 0];
    [0; 0; 0; 0; 1; 1; 0; 0; 1; 1; 1];
    [0; 0; 0; 0; 1; 1; 0; 1; 0; 0; 0];
    [0; 0; 0; 0; 1; 1; 0; 1; 1; 0; 0];
    [0; 0; 0; 0; 0; 1; 1; 0; 1; 1; 1];
    [0; 0; 0; 0; 0; 1; 0; 1; 0; 0; 0];
    [0; 0; 0; 0; 0; 0; 1; 0; 1; 1; 1];
    [0; 0; 0; 0; 0; 0; 1; 1; 0; 0; 0];
    [0; 0; 0; 0; 1; 1; 0; 0; 1; 0; 1; 0];
    [0; 0; 0; 0; 1; 1; 0; 0; 1; 0; 1; 1];
    [0; 0; 0; 0; 1; 1; 0; 0; 1; 1; 0; 0];
    [0; 0; 0; 0; 1; 1; 0; 0; 1; 1; 0; 1];
    [0; 0; 0; 0; 0; 1; 1; 0; 1; 0; 0; 0];
    [0; 0; 0; 0; 0; 1; 1; 0; 1; 0; 0; 1];
    [0; 0; 0; 0; 0; 1; 1; 0; 1; 0; 1; 0];
    [0; 0; 0; 0; 0; 1; 1; 0; 1; 0; 1; 1];
    [0; 0; 0; 0; 1; 1; 0; 1; 0; 0; 1; 0];
    [0; 0; 0; 0; 1; 1; 0; 1; 0; 0; 1; 1];
    [0; 0; 0; 0; 1; 1; 0; 1; 0; 1; 0; 0];
    [0; 0; 0; 0; 1; 1; 0; 1; 0; 1; 0; 1];
    [0; 0; 0; 0; 1; 1; 0; 1; 0; 1; 1; 0];
    [0; 0; 0; 0; 1; 1; 0; 1; 0; 1; 1; 1];
    [0; 0; 0; 0; 0; 1; 1; 0; 1; 1; 0; 0];
    [0; 0; 0; 0; 0; 1; 1; 0; 1; 1; 0; 1];
    [0; 0; 0; 0; 1; 1; 0; 1; 1; 0; 1; 0];
    [0; 0; 0; 0; 1; 1; 0; 1; 1; 0; 1; 1];
    [0; 0; 0; 0; 0; 1; 0; 1; 0; 1; 0; 0];
    [0; 0; 0; 0; 0; 1; 0; 1; 0; 1; 0; 1];
    [0; 0; 0; 0; 0; 1; 0; 1; 0; 1; 1; 0];
    [0; 0; 0; 0; 0; 1; 0; 1; 0; 1; 1; 1];
    [0; 0; 0; 0; 0; 1; 1; 0; 0; 1; 0; 0];
    [0; 0; 0; 0; 0; 1; 1; 0; 0; 1; 0; 1];
    [0; 0; 0; 0; 0; 1; 0; 1; 0; 0; 1; 0];
    [0; 0; 0; 0; 0; 1; 0; 1; 0; 0; 1; 1];
    [0; 0; 0; 0; 0; 0; 1; 0; 0; 1; 0; 0];
    [0; 0; 0; 0; 0; 0; 1; 1; 0; 1; 1; 1];
    [0; 0; 0; 0; 0; 0; 1; 1; 1; 0; 0; 0];
    [0; 0; 0; 0; 0; 0; 1; 0; 0; 1; 1; 1];
    [0; 0; 0; 0; 0; 0; 1; 0; 1; 0; 0; 0];
    [0; 0; 0; 0; 0; 1; 0; 1; 1; 0; 0; 0];
    [0; 0; 0; 0; 0; 1; 0; 1; 1; 0; 0; 1];
    [0; 0; 0; 0; 0; 0; 1; 0; 1; 0; 1; 1];
    [0; 0; 0; 0; 0; 0; 1; 0; 1; 1; 0; 0];
    [0; 0; 0; 0; 0; 1; 0; 1; 1; 0; 1; 0];
    [0; 0; 0; 0; 0; 1; 1; 0; 0; 1; 1; 0];
    [0; 0; 0; 0; 0; 1; 1; 0; 0; 1; 1; 1]|]

let white_make_up_codes =
  [|[1; 1; 0; 1; 1];
    [1; 0; 0; 1; 0];
    [0; 1; 0; 1; 1; 1];
    [0; 1; 1; 0; 1; 1; 1];
    [0; 0; 1; 1; 0; 1; 1; 0];
    [0; 0; 1; 1; 0; 1; 1; 1];
    [0; 1; 1; 0; 0; 1; 0; 0];
    [0; 1; 1; 0; 0; 1; 0; 1];
    [0; 1; 1; 0; 1; 0; 0; 0];
    [0; 1; 1; 0; 0; 1; 1; 1];
    [0; 1; 1; 0; 0; 1; 1; 0; 0];
    [0; 1; 1; 0; 0; 1; 1; 0; 1];
    [0; 1; 1; 0; 1; 0; 0; 1; 0];
    [0; 1; 1; 0; 1; 0; 0; 1; 1];
    [0; 1; 1; 0; 1; 0; 1; 0; 0];
    [0; 1; 1; 0; 1; 0; 1; 0; 1];
    [0; 1; 1; 0; 1; 0; 1; 1; 0];
    [0; 1; 1; 0; 1; 0; 1; 1; 1];
    [0; 1; 1; 0; 1; 1; 0; 0; 0];
    [0; 1; 1; 0; 1; 1; 0; 0; 1];
    [0; 1; 1; 0; 1; 1; 0; 1; 0];
    [0; 1; 1; 0; 1; 1; 0; 1; 1];
    [0; 1; 0; 0; 1; 1; 0; 0; 0];
    [0; 1; 0; 0; 1; 1; 0; 0; 1];
    [0; 1; 0; 0; 1; 1; 0; 1; 0];
    [0; 1; 1; 0; 0; 0];
    [0; 1; 0; 0; 1; 1; 0; 1; 1]|]

let black_make_up_codes =
  [|[0; 0; 0; 0; 0; 0; 1; 1; 1; 1];
    [0; 0; 0; 0; 1; 1; 0; 0; 1; 0; 0; 0];
    [0; 0; 0; 0; 1; 1; 0; 0; 1; 0; 0; 1];
    [0; 0; 0; 0; 0; 1; 0; 1; 1; 0; 1; 1];
    [0; 0; 0; 0; 0; 0; 1; 1; 0; 0; 1; 1];
    [0; 0; 0; 0; 0; 0; 1; 1; 0; 1; 0; 0];
    [0; 0; 0; 0; 0; 0; 1; 1; 0; 1; 0; 1];
    [0; 0; 0; 0; 0; 0; 1; 1; 0; 1; 1; 0; 0];
    [0; 0; 0; 0; 0; 0; 1; 1; 0; 1; 1; 0; 1];
    [0; 0; 0; 0; 0; 0; 1; 0; 0; 1; 0; 1; 0];
    [0; 0; 0; 0; 0; 0; 1; 0; 0; 1; 0; 1; 1];
    [0; 0; 0; 0; 0; 0; 1; 0; 0; 1; 1; 0; 0];
    [0; 0; 0; 0; 0; 0; 1; 0; 0; 1; 1; 0; 1];
    [0; 0; 0; 0; 0; 0; 1; 1; 1; 0; 0; 1; 0];
    [0; 0; 0; 0; 0; 0; 1; 1; 1; 0; 0; 1; 1];
    [0; 0; 0; 0; 0; 0; 1; 1; 1; 0; 1; 0; 0];
    [0; 0; 0; 0; 0; 0; 1; 1; 1; 0; 1; 0; 1];
    [0; 0; 0; 0; 0; 0; 1; 1; 1; 0; 1; 1; 0];
    [0; 0; 0; 0; 0; 0; 1; 1; 1; 0; 1; 1; 1];
    [0; 0; 0; 0; 0; 0; 1; 0; 1; 0; 0; 1; 0];
    [0; 0; 0; 0; 0; 0; 1; 0; 1; 0; 0; 1; 1];
    [0; 0; 0; 0; 0; 0; 1; 0; 1; 0; 1; 0; 0];
    [0; 0; 0; 0; 0; 0; 1; 0; 1; 0; 1; 0; 1];
    [0; 0; 0; 0; 0; 0; 1; 0; 1; 1; 0; 1; 0];
    [0; 0; 0; 0; 0; 0; 1; 0; 1; 1; 0; 1; 1];
    [0; 0; 0; 0; 0; 0; 1; 1; 0; 0; 1; 0; 0];
    [0; 0; 0; 0; 0; 0; 1; 1; 0; 0; 1; 0; 1]|]



(** For this exercise. *)

type code = int list
type 'a tree = Empty | Leaf of 'a | Branch of 'a tree * 'a tree
type value = Terminal of int | MakeUp of int

let rec insert value (code : code) tree =
  match tree, code with
  (* trying to insert at a leaf *)
  | Leaf _, _ -> failwith "Codes have common prefix"
  (* trying to insert at a branch *)
  | Branch _, [] -> failwith "Codes have common prefix"
  | Branch (l, r), 0 :: code' ->
      Branch (insert value code' l, r)
  | Branch (l, r), 1 :: code' ->
      Branch (l, insert value code' r)
  | Branch _, _ ->
      failwith "Code contains a digit other than 0 or 1"
  (* trying to insert at at empty node *)
  | Empty, [] -> Leaf value
  | Empty, 0 :: code' ->
      Branch (insert value code' Empty, Empty)
  | Empty, 1 :: code' ->
      Branch (Empty, insert value code' Empty)
  | Empty, _ ->
      failwith "Code contains digit other than 0 or 1"

let insert_array (arr : (value * code) array) tree =
  let n = Array.length arr in
  let rec loop i acc =
    if i >= n then acc
    else
      let value, code = arr.(i) in
      loop (i + 1) (insert value code acc)
  in
  loop 0 tree

let make_pair_array f arr =
  Array.mapi (fun i x -> (f i, x) ) arr

let make_tree terminating_codes make_up_codes =
  let terminating_pair_array =
    make_pair_array (fun i -> Terminal i) terminating_codes
  in
  let make_up_pair_array =
    make_pair_array (fun i -> MakeUp (64 + (i * 64))) make_up_codes
  in
  Empty
  |> insert_array terminating_pair_array
  |> insert_array make_up_pair_array

let white_tree = make_tree white_terminating_codes white_make_up_codes
let black_tree = make_tree black_terminating_codes black_make_up_codes



(** Testing *)

let rec code_list_of_tree tree : (value * code) list =
  match tree with
  | Empty -> []
  | Leaf value -> [(value, [])]
  | Branch (l, r) ->
      let left_codes = code_list_of_tree l in
      let codes0 =
        List.map (fun (value, code) -> (value, 0 :: code)) left_codes
      in
      let right_codes = code_list_of_tree r in
      let codes1 =
        List.map (fun (value, code) -> (value, 1 :: code)) right_codes
      in
      codes0 @ codes1

let check_code terminating_codes make_up_codes (value, code) =
  match value with
  | Terminal i ->
      terminating_codes.(i) = code
  | MakeUp n ->
      make_up_codes.(n / 64 - 1) = code

let _ =
  List.for_all
    (check_code white_terminating_codes white_make_up_codes)
    (code_list_of_tree white_tree)

let _ =
  List.for_all
    (check_code black_terminating_codes black_make_up_codes)
    (code_list_of_tree black_tree)