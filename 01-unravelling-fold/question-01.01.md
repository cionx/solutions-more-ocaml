# Question 1.1

> Write a function which, given a list of integers representing expenses, removes them from a budget, again represented by an integer.

---

We can write the described function as follows:
```ocaml
let total budget expenses =
  List.fold_left (fun acc e -> acc - e) budget expenses
```
