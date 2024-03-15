# Question 3.3

> What is the difference between `type t = {x : int ref}` and `type t = {mutable x : int}`?
> What are the advantages and disadvantages of each?

---

There isn’t much difference between the two of them:

1. For the first type we use `:=` to change the value, as in `t.x := 0`.
   For the second type we use `<-` insteady as in `t.x <- 0`.

2. With the first type, two values of type `t` can share a reference:
   ```ocaml
   let xref = ref 0
   let t1 = {x = xref}
   let t2 = {x = xref}
   ```
   This is not possible with the second definition.
