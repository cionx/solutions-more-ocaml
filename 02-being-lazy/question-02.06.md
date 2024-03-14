# Question 2.6

> Alphanumeric labels in documents go A, B, C, …, X, Y, Z, AA, AB, …, BA, BB, …, AAA, …
> Write the lazy list containing strings representing this sequence.
> You may (mis)use the Standard Library function `Char.escaped` to convert a character to a string.

---

We define an auxiliary function `alphanum_of_int` that converts a number to the corresponding alphanumeric label:
```ocaml
let letter_of_int n =
  Char.chr (Char.code 'A' + n)

let alphanum_of_int n =
  let rec loop k acc =
    if k < 0 then acc
    else
      let digit = letter_of_int (k mod 26) in
      loop (k / 26 - 1) (String.make 1 digit ^ acc)
  in
  loop n ""
```

We can now implement the desired lazy list as follows:
```ocaml
let rec labels' n =
  Cons (alphanum_of_int n, fun () -> labels' (n + 1))

let labels = labels' 0
```
