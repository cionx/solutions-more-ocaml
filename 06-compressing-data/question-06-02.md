# Question 6.2

> Replace our manual tree of codes with a tree automatically generated from the lists of codes used for compression.
> The tree will have no data at its branches (since no code is a prefix of another), and will have data at only some of its leaves.
> Define a suitable data type first.

---

### Implementation

By a “code” we mean a list of zeroes and ones:
```ocaml
type code = int list
```
We use the following type for trees:
```ocaml
type 'a tree = Empty | Leaf of 'a | Branch of 'a tree * 'a tree
```
As an example, consider the following codes for the numbers from one to five:
```text
1 010
2 011
3 10
4 110
5 111
```
The corresponding tree is as follows:
```text
         B
        / \
       /   \
      /     \
     /       \
    /         \
   B           B
  / \         / \
 /   \       /   \
E     B     L 3   B
     / \         / \
    /   \       /   \
   L 1  L 2    L 4  L 5
```

We will use the following type for the leaves of our trees:
```ocaml
type value = Terminal of int | MakeUp of int
```

It is our job to convert the code arrays `white_terminating_codes` and `white_make_up_codes` into a tree `whine_tree`, and the code arrays `black_terminating_codes` and `black_make_up_codes` into a tree `black_tree`.

The main work is done by the following function, which inserts a `value` into a `tree` relative to a provided `code`:
```ocaml
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
```
The following function inserts an entire array of `(value, code)` pairs into a given tree:
```ocaml
let insert_array (arr : (value * code) array) tree =
  let n = Array.length arr in
  let rec loop i acc =
    if i >= n then acc
    else
      let value, code = arr.(i) in
      loop (i + 1) (insert value code acc)
  in
  loop 0 tree
```
The following functions create such an array from `white_terminating_codes` and `white_terminating_codes`, as well as from `black_terminating_codes` and `black_make_up_codes`, and then create the corresponding tree:
```ocaml
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
```
We can now create the two trees as follows:
```ocaml
let white_tree = make_tree white_terminating_codes white_make_up_codes
let black_tree = make_tree black_terminating_codes black_make_up_codes
```

### Testing

We test the above code by reconstructing the original codes from the trees.
The following function translates a tree into a list of pairs `[(value1, code1), ... (valuen, coden)]`:
```ocaml
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
```
We can now check the constructed trees as follows:
```ocaml
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
```
Both checks result in `true`.
