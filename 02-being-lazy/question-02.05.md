# Question 2.5

> Write the function `unleave` which, given a lazy list, returns two lazy lists, one containing elements at positions 0, 2, 4, 6, … of the original list, and the other containing elements at positions 1, 3, 5, 7, …

---

We can implement the function `unleave` as follows:
```ocaml
let rec every_snd l =
  Cons (lhd l, fun () -> every_snd (ltl (ltl l)))

let unleave l =
  (every_snd l, every_snd (ltl l))
```
