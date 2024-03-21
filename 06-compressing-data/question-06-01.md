# Question 6.1

> How much complexity did using the `input` and `output` types add to compress and decompress in our byte-by-byte example?
> Rewrite the functions so they just operate over lists of integers, in functional style, and compare the two.

---

### Complexity

The extra complexity seems okay?

### Alternative implementation

We use the usual auxiliary functions `take` and `drop`:
```ocaml
let rec take n l =
  match n, l with
  | 0, _ | _, [] -> []
  | n, h :: t -> h :: take (n - 1) t

let rec drop n l =
  match n, l with
  | 0, _ | _, [] -> l
  | n, h :: t -> drop (n - 1) t
```

We decode as follows:
```ocaml
(** [mklist n x] is the list [[x; x; ...; x]] of length [n]. *)
let mklist n x =
  List.init n (fun _ -> x)

let rec decode l =
  match l with
  | n :: t when 0 <= n && n <= 127 ->
      take (n + 1) t @ decode (drop (n + 1) t)
  | n :: x :: t when 128 < n && n <= 255 ->
      mklist (257 - n) x @ decode t
  | 128 :: _ -> []
  | _ -> failwith "decode: invalid run length"
```

The following functions determine the maximal number `n` such that the first `n` elements of a list are equal/pairwise distinct.
```ocaml
let get_same l =
  match l with
  | [] -> 0
  | x :: xs ->
      let rec loop count list =
        if count = 128 then 128
      else
        match list with
        | h :: t when h = x -> loop (count + 1) t
        | _ -> count
      in
    loop 1 xs

let get_different l =
  match l with
  | [] -> 0
  | x :: xs ->
      let rec loop count prev list =
        match list with
        | [] -> count
        | h :: t when h = prev -> count - 1
        | h :: t -> loop (count + 1) h t
      in
      loop 1 x xs
```
We can now encode messages:
```ocaml
let rec encode l =
  match l with
  | [] -> [128]
  | x :: y :: t when x = y ->
      let n = get_same l in
      (257 - n) :: x :: encode (drop n l)
  | _ ->
      let n = get_different l in
      (n - 1) :: (take n l) @ encode (drop n l)
```

### Comparison

Pattern matching allows for a cleaner code and requires no rewinding.
But handling lists (and list concatenation) is maybe less efficient than simply printing to the output.
