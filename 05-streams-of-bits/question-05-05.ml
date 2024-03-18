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

type output_bits = {
  output: output;
  mutable obyte: int;
  mutable obit: int
}

let output_bits_of_output o =
  { output = o; obyte = 0; obit = 7 }

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

let putval o v l =
  for x = l - 1 downto 0 do
    putbit o (v land (1 lsl x))
  done



(** Testing. *)

let bytes = Bytes.create 10
let out = output_bits_of_output (output_of_bytes bytes)
let _ = for n = 97 to 106 do putval out n 8 done
let _ = Bytes.to_string bytes
