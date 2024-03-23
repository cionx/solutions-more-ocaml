# Question 7.1

> The function `ArrayLabels.make` is not labelled, having type `int → α → α array`.
> When might this cause confusion?
> Write a labelled version to correct this problem.

---

We might run into a problem when we try to create an `int array`, as the first two arguments of `ArrayLabels.make` are then both of type `int`.
We can implement a labelled version as follows:
```ocaml
let make_array ~length ~value =
  Array.make length value
```
