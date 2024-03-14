# Question 2.4

> Write a lazy list whose elements are the Fibonacci numbers 0, 1, 1, 2, 3, 5, 8, … whose first two elements are zero and one by definition, and each ensuing element is the sum of the previous two.

---

We can implement the Fibonacci sequence as follows:
```ocaml
let rec fib' (a, b) =
  Cons (a, fun () -> fib' (b, a + b))

let fib = fib' (0, 1)
```
