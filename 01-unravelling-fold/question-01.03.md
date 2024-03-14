# Question 1.3

> Use one of the `fold_` functions to find the last element of list, if any.
> Behave sensibly if the list is empty.

---

We use `fold_left` since it is tail-recursive:
```ocaml
let last l =
  match l with
  | [] -> invalid_arg "last: empty list"
  | h :: t -> List.fold_left (fun _ x -> x) h t
```
