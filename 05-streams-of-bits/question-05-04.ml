(** From the textbook. *)

type output = {
  output_char : char -> unit;
  out_channel_length : unit -> int
}

let output_of_channel ch =
  {
    output_char = output_char ch;
    out_channel_length = (fun () -> out_channel_length ch);
  }

type output_bits = {
  output: output;
  mutable obyte: int;
  mutable obit: int
}

let output_bits_of_output o =
  { output = o; obyte = 0; obit = 7 }

let flush o =
  if o.obit < 7 then o.output.output_char (char_of_int o.obyte);
  o.obyte <- 0;
  o.obit <- 7

let rec putbit o b =
  if o.obit = (-1) then
    begin
      flush o;
      putbit o b
      end
  else
    begin
      if b <> 0 then o.obyte <- o.obyte lor (1 lsl o.obit);
      o.obit <- o.obit - 1
      end

let putval o v l =
  for x = l - 1 downto 0 do
    putbit o (v land (1 lsl x))
  done



(** For this exercise. *)

let putval_32 o v l =
  for x = l - 1 downto 0 do
    let bit = Int32.logand v (Int32.shift_left 1l x) > 0l in
    putbit o (if bit then 1 else 0)
  done



(** For testing. *)

let output_header filename =
  let ch = open_out_bin filename in
  let o = output_of_channel ch in
  let bits = output_bits_of_output o in
  putval bits 38 16;
  putval bits 47892 16;
  putval_32 bits 1656212531l 32;
  putval_32 bits 1481973485l 32;
  putval bits 5 4;
  putval bits 0 6;
  putbit bits 0;
  putbit bits 0;
  putbit bits 0;
  putbit bits 0;
  putbit bits 0;
  putbit bits 0;
  putval bits 17664 16;
  putval bits 888 16;
  putval bits 63404 16;
  flush bits;
  close_out ch

let _ = output_header "question-05-04.test"
