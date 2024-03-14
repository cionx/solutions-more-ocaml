# Question 1.7

> Use `fold_tree` to write a function which calculates the maximum depth of a tree.
> What is its type?

---

We can implement the function `fold_tree` as follows:
```ocaml
let depth t =
  fold_tree (fun x l r -> 1 + max l r) 0 t
```
It is of type `'a tree -> int`.
