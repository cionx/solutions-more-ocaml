# Question 1.8

> Compare the time efficiency of one or more of your functions with the system implementation of the same function (for example, our fold-based member function vs. `List.mem`) with regard to both computational complexity and actual time taken.

---

We use the following auxiliary function to time the functions in question:
```ocaml
let time f x =
  let t1 = Sys.time () in
  let _ = f x in
  let t2 = Sys.time () in
  t2 -. t1
```

### Question 1.2

We compare our function `length` from Question 1.2 to `List.length` as follows:
```ocaml
let gen_list n =
  List.init n Fun.id

let test_length n =
  let l = gen_list n in
  let t_std = time List.length l in
  let t_own = time length l in
  Format.printf "std: %g\nown: %g\n" t_std t_own
```
We get the following times:
| `n` in millions | `length` | `List.length` |
| --------------: | -------: | ------------: |
|               1 | 0.055578 |      0.023673 |
|              10 | 0.556952 |      0.231061 |
|             100 | 5.544970 |      2.188440 |

We see that `List.length` is about twice as fast as `length`, and both functions have linear time complexity.
(We haven’t tested larger values of `n` since your machine is running out of RAM.)

### Question 1.5

The running time of `List.mem x l` depends on the position of `x` in `l`.
Our function `mem` from Question 1.5 does not depend on this, but is slower than `List.mem`, because
- it generates intermediate lists
- it does not use short-circuiting of logical operators.

I don’t know how to properly measure the running time of `List.mem`, given how it depends on its arguments.
