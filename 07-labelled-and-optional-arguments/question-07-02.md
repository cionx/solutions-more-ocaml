# Question 7.2

> When we wrote our fill function with labelled arguments, we wanted to prevent someone mistakenly swapping the start and length values.
> Can you find a way to do this without labelled or optional arguments?

---

As mentioned in the hints, we could declare auxiliary types for the start and length:
```ocaml
type length = Len of int
type index = Ind of int

let fill arr (Ind s) (Len l) v =
  for x = s to s + l - 1 do arr.(x) <- v done
```
