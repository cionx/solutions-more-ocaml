# Question 4.2

> Write a function `input_string` of type `input → int → string` which returns the given number of characters from the input as a string, or fewer if the input has ended.

---

We can write the described function as follows:
```ocaml
let input_string i n =
  let buf = Buffer.create n in
  let rec loop k =
    if k <= 0 then ()
    else try
      Buffer.add_char buf (i.input_char ());
      loop (k - 1)
    with
      End_of_file -> ()
  in
  loop n;
  Buffer.contents buf
```
