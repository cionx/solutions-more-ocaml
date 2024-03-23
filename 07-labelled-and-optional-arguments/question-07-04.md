# Question 7.4

> Frequently we use an accumulator to make a function tail-recursive, wrapping it up in another function to give the initial value of the accumulator.
> For example, we might write:
> ```ocaml
> let rec map_inner a f l =
>   match l with
>   | [] -> List.rev a
>   | h :: t -> map_inner (f h :: a) f t
>
> let map f l = map_inner [] f l
> ```
> Use an optional argument to express this as a single function.

---

We can use the following function:
```ocaml
let rec map ?(a = []) f l =
  match l with
  | [] -> List.rev a
  | h :: t -> map ~a:(f h :: a) f t
```
