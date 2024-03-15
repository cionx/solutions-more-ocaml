# Question 4.3

> Extend the `input` type to include a function `input_char_opt` which returns a value of type `char option`, with `None` signalling end of file.
> Extend the functions `input_of_channel` and `input_of_string` appropriately.

---

We add the described function to the type `input`:
```ocaml
type input = {
  pos_in : unit -> int;
  seek_in : int -> unit;
  input_char : unit -> char;
  input_char_opt : unit -> char option; (* new function *)
  in_channel_length : int;
}
```

We can uniformly implement the new function `input_char_opt` in terms of the already existing function `input_char`:
```ocaml
let input_of_channel ch =
  let ic () = input_char ch in
  {
    pos_in = (fun () -> pos_in ch);
    seek_in = seek_in ch;
    input_char = ic;
    input_char_opt =
      (fun () -> try Some (ic ()) with End_of_file -> None);
    in_channel_length = in_channel_length ch;
  }

let input_of_string s =
  let pos = ref 0 in
  let ic () =
    if !pos > String.length s - 1
    then raise End_of_file
    else (let c = s.[!pos] in pos := !pos + 1; c)
  in
  {
    pos_in = (fun () -> !pos);
    seek_in =
      (fun p ->
        if p < 0 then invalid_arg "seek before beginning"
        else pos := p);
    input_char = ic;
    input_char_opt =
      (fun () -> try Some (ic ()) with End_of_file -> None);
    in_channel_length = String.length s
  }
```
