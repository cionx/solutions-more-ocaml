# Question 1.5

> Write a version of `List.mem` using one of the `fold_` functions.
> Now `setify` can be defined entirely using folds.

---

We can implement `List.mem` in terms of `exists`, which in turn can be implemented in terms of `any`, which in turn is implemented in terms of the `fold_` functions:
```ocaml
(** [exists p l] is wheter [p x] for some element [x] of [l]. *)
let exists p l =
  any (List.map p l)

let mem x l =
  exists (( = ) x) l
```
