# Question 1.2

> Calculate the length of a list using one of the `fold_` functions.

---

We use `fold_left` since it is tail-recursive:
```ocaml
let length l =
  List.fold_left (fun acc _ -> acc + 1) 0 l
```
