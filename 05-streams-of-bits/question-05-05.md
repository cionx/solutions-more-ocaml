# Question 5.5

> We said that the `output_bits` type needed a `flush` operation.
> In fact, this is not always true – for outputs built with, for example, `output_of_bytes,` we could write the current byte every time a bit is written, seeking back one byte each time, only moving on when the byte is actually finished.
> Implement this.

---

We stop the `output` from automatically moving forward whenever `output_char` is invoked.
Instead, the type `output` has to specify a function `seek_forward`.
```ocaml
type output = {
  output_char : char -> unit;
  seek_forward : unit -> unit;
  out_channel_length : unit -> int
}

let output_of_bytes b =
  let pos = ref 0 in
  {
    output_char =
      (fun c ->
        if !pos < Bytes.length b then Bytes.set b !pos c
        else raise End_of_file);
    seek_forward = (fun () -> pos := !pos + 1);
    out_channel_length = (fun () -> Bytes.length b)
  }
```
The definitions of `output_bits` and `output_bits_of_output` remain unchanged.
The code for `putbit` is now as follows:
```ocaml
let putbit o b =
  if o.obit = (-1) then
    begin
      o.output.seek_forward ();
      o.obyte <- 0;
      o.obit <- 7;
    end;
  if b <> 0 then o.obyte <- o.obyte lor (1 lsl o.obit);
  o.output.output_char (char_of_int o.obyte);
  o.obit <- o.obit - 1
```
The code for `putval` remains unchanged.
