# Question 1.6

> Use a fold to write a function which, given a list of non-empty strings representing words, returns a single string where the words are separated by spaces.
> Comment on its efficiency.

---

We can write a general `join` function using either `fold_` function:
```ocaml
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
```
We don’t know the complexity of string concatenation, and how it depends on the lengths of the two inputs.
So we cannot say which of the two functions is more efficient.

But we can compare both functions on a test list of strings.
We choose the list `["a", "a", "a", ...]` of length `n` and the separator `""`, and time our functions with the following auxiliary function:
```ocaml
let time f x =
  let t1 = Sys.time () in
  let _ = f x in
  let t2 = Sys.time () in
  t2 -. t1
```
We get the following results:

|       `n` | `join_left` | `join_right` |
| --------: | ----------: | -----------: |
|   100,000 |   5.681553  |    18.841738 |
|   200,000 |  23.210775  |   103.969799 |
|   400,000 |  95.314078  |   553.276977 |
|   800,000 | 389.175706  |              |

We see that
- the running time of `join_left` seems to be roughly quadratic in `n`.
- `join_left` is faster than `join_right`
- (doubling the input size `n` seems to increase the running time of `join_right` by a factor of 5)
