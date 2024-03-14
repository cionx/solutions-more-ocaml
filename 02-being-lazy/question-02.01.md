# Question 2.1

> Write the lazy list whose elements are the numbers `1, 2, 4, 8, 16, ...`
> What is its type?

---

We can declare this lazy list as follows:
```ocaml
let rec pow2' n =
  Cons (n, fun () -> pow2' (2 * n))

let pow2 = pow2' 1
```
The lazy list `pow2` is of type `int lazylist`.
