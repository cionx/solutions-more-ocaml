# Question 4.4

> Extend the `input` type with a function `input_byte` which returns an integer representing the next byte, or the special value `−1` at end of file.
> Comment on the usefulness of this compared with `input_char_opt` and `input_char.`

---

We extend the type `input` by the described function:
```ocaml
type input = {
  pos_in : unit -> int;
  seek_in : int -> unit;
  input_char : unit -> char;
  input_byte : unit -> int;   (* new function *)
  in_channel_length : int;
}
```
We can uniformly implement `input_byte` in terms of `input_char`:
```ocaml
let input_of_channel ch =
  let ic () = input_char ch in
  {
    pos_in = (fun () -> pos_in ch);
    seek_in = seek_in ch;
    input_char = ic;
    input_byte =
      (fun () -> try int_of_char (ic ()) with End_of_file -> -1);
    in_channel_length = in_channel_length ch;
  }

let input_of_string s =
  let pos = ref 0 in
  let ic () =
    if !pos > String.length s - 1
    then raise End_of_file
    else (let c = s.[!pos] in pos := !pos + 1; c);
  in
  {
    pos_in = (fun () -> !pos);
    seek_in =
      (fun p ->
        if p < 0 then invalid_arg "seek before beginning"
        else pos := p);
    input_char = ic;
    input_byte =
      (fun () -> try int_of_char (ic ()) with End_of_file -> -1);
    in_channel_length = String.length s
  }
```

The function `input_byte` doesn’t seem very useful since it is just a wrapper around `input_char`.
