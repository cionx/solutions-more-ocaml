# Question 3.4

> Define a record of six items `a`, …, `f` where `a` and `b` have the same type as one another, `c` and `d` have the same type as one another and `e` and `f` have the same type as one another.

---

Here is an examplo of such a record (type):
```ocaml
type t = { a : int; b : int; c : float; d : float; e : string; f : string }

let r = { a = 0; b = 1; c = 0.; d = 1.; e = "0"; f = "1" }
```
