# Question 2.2

> Write a function to return the `n`th element of a lazy list where element zero is the head of the list.

---

We can implement the described function as follows:
```ocaml
let rec lnth l n =
  if n <= 0 then lhd l else lnth (ltl l) (n - 1)
```
