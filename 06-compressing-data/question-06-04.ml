(** From the textbook. *)

(** Input *)

type input = {
  pos_in : unit -> int;
  seek_in : int -> unit;
  input_char : unit -> char;
  in_channel_length : int;
}

let input_of_string s =
  let pos = ref 0 in
  {
    pos_in = (fun () -> !pos);
    seek_in =
      (fun p ->
        if p < 0 then invalid_arg "seek before beginning"
        else pos := p);
    input_char =
      (fun () ->
        if !pos > String.length s - 1
        then raise End_of_file
        else (let c = s.[!pos] in pos := !pos + 1; c));
    in_channel_length = String.length s
  }

let rewind i =
  i.seek_in (i.pos_in () - 1)

type input_bits = {
  input: input;
  mutable byte: int;
  mutable bit: int
}

let input_bits_of_input i =
  { input = i; byte = 0; bit = 0 }

(** Output *)

type output = {
  output_char : char -> unit;
  out_channel_length : unit -> int
}

type output_bits = {
  output: output;
  mutable obyte: int;
  mutable obit: int
}

let output_of_buffer b =
  {
    output_char = Buffer.add_char b;
    out_channel_length = (fun () -> Buffer.length b)
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

(** Advanced functions. *)

let packedstring_of_string s =
  let b = Buffer.create ((String.length s / 8) + 1) in
  let o = output_bits_of_output (output_of_buffer b) in
  for x = 0 to String.length s - 1 do
    putbit o (if s.[x] = '1' then 1 else 0)
  done;
  flush o;
  Buffer.contents b

let rec getbit b =
  if b.bit = 0 then
    begin
      b.byte <- int_of_char (b.input.input_char ());
      b.bit <- 128;
      getbit b
    end
  else
    let result = b.byte land b.bit > 0 in
    b.bit <- b.bit / 2;
    result

let peekbit b =
  if b.bit = 0 then
    begin
      let byte = int_of_char (b.input.input_char ()) in
      rewind b.input;
      byte land 128 > 0
    end
  else
    b.byte land b.bit > 0

let rec read_up_to v i n w =
  if n >= w then (n, v) else
  if peekbit i = v
  then (ignore (getbit i); read_up_to v i (n + 1) w)
  else (n, v)



(** For this exercise. *)

let count_runs i w h =
  let counter_white = Array.make (w + 1) 0 in
  let counter_black = Array.make (w + 1) 0 in
  let rec process_line w =
    if w > 0 then begin
      let (n, isblack) = read_up_to (peekbit i) i 0 w in
      if isblack then
        counter_black.(n) <- counter_black.(n) + 1
      else
        counter_white.(n) <- counter_white.(n) + 1;
      process_line (w - n)
      end
  in
  for _ = 1 to h do
    if peekbit i then counter_white.(0) <- counter_white.(0) + 1;
    process_line w
  done;
  (counter_white, counter_black)

let print_histogram i w h =
  let print_array name arr =
    print_string name;
    print_string "\n";
    for i = 0 to w do
      if arr.(i) > 0 then begin
        print_string "\t";
        print_int i;
        print_string " - ";
        print_int arr.(i);
        print_string "\n"
        end
    done
  in
  let counter_white, counter_black = count_runs i w h in
  print_array "white" counter_white;
  print_string "\n";
  print_array "black" counter_black



(** Testing *)

let input_data =
  "00000000\
   11111111\
   00001111\
   11110000\
   00110011\
   11001100\
   01010101\
   10101010"
(* expected histogram:
    white
      0 - 4
      1 - 8
      2 - 4
      4 - 2
      8 - 1
    black
      1 - 8
      2 - 4
      4 - 2
      8 - 1 *)

let packed_data = packedstring_of_string input_data
let i = input_bits_of_input (input_of_string packed_data)

let () = print_histogram i 8 8
