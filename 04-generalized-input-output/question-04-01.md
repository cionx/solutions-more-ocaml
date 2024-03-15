# Question 4.1

> Write a function to build an input from an array of characters.

---

We can write this function as follows:
```ocaml
let input_of_array arr =
  let pos = ref 0 in
  {
    pos_in = (fun () -> !pos);
    seek_in =
      (fun p ->
        if p < 0 then invalid_arg "seek before beginning"
        else pos := p);
    input_char =
      (fun () ->
        if !pos >= Array.length arr then raise End_of_file
        else let c = arr.(!pos) in (pos := !pos + 1; c));
    in_channel_length = Array.length arr
  }
```
