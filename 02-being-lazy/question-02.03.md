# Question 2.3

> Write a function which, given a list, returns the lazy list forming a repeated sequence taken from that list.
> For example, given the list `[1; 2; 3]` it should return a lazy list with elements `1, 2, 3, 1, 2, 3, 1, 2, ...`

---

We can implement the described function as follows:
```ocaml
let repeat l =
  let rec loop l' =
    match l' with
    | [] -> loop l
    | h :: t ->
      Cons (h, fun () -> loop t)
  in
  loop l
```
