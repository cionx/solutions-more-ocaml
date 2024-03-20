(** Input. *)

type input = {
  pos_in : unit -> int;
  seek_in : int -> unit;
  input_char : unit -> char;
  in_channel_length : int;
}

let input_of_channel ch =
  {
    pos_in = (fun () -> pos_in ch);
    seek_in = seek_in ch;
    input_char = (fun () -> input_char ch);
    in_channel_length = in_channel_length ch;
  }

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


type input_bits = {
  input: input;
  mutable byte: int;
  mutable bit: int
}

let input_bits_of_input i =
  { input = i; byte = 0; bit = 0 }

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

let align b =
  b.bit <- 0

let getval b n =
  if n <= 0 || n > 31 then invalid_arg "getval"
  else
    let r = ref 0 in
    for x = n - 1 downto 0 do
      r := !r lor ((if getbit b then 1 else 0) lsl x)
    done;
    !r

let getval_32 b n =
  if n <= 0 || n > 32 then invalid_arg "getval32"
  else
    let r = ref 0l in
    for x = n - 1 downto 0 do
      r := Int32.logor !r (Int32.shift_left (if getbit b then 1l else 0l) x)
    done;
    !r

let print_header filename =
  let ch = open_in_bin filename in
  let i = input_of_channel ch in
  let b = input_bits_of_input i in
  let src_port = getval b 16 in
  let dest_port = getval b 16 in
  let seq_number = getval_32 b 32 in
  let ack_number = getval_32 b 32 in
  let _ = getval b 4 in (* data offset *)
  let _ = getval b 6 in (* reserved *)
  let urgent = getbit b in
  let ack = getbit b in
  let push = getbit b in
  let reset = getbit b in
  let syn = getbit b in
  let fin = getbit b in
  let receive = getval b 16 in
  let checksum = getval b 16 in
  let urgent_pointer = getval b 16 in
  let print_bool b = print_string (string_of_bool b) in
  print_string "Source port = ";
  print_int src_port;
  print_string "\nDestination = ";
  print_int dest_port;
  print_string "\nSequence = ";
  print_string (Int32.to_string seq_number);
  print_string "\nAcknowledgement Number = ";
  print_string (Int32.to_string ack_number);
  print_string "\nFlags:\n Urgent = ";
  print_bool urgent;
  print_string "\n Ack = ";
  print_bool ack;
  print_string "\n Push = ";
  print_bool push;
  print_string "\n Reset = ";
  print_bool reset;
  print_string "\n Syn = ";
  print_bool syn;
  print_string "\n Fin = ";
  print_bool fin;
  print_string "\nReceive window size = ";
  print_int receive;
  print_string "\nChecksum = ";
  print_int checksum;
  print_string "\nUrgent pointer = ";
  print_int urgent_pointer;
  print_string "\n";
  close_in ch



(** Output. *)

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

let putval_32 o v l =
  for x = l - 1 downto 0 do
    let bit = Int32.logand v (Int32.shift_left 1l x) > 0l in
    putbit o (if bit then 1 else 0)
  done

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

(** For testing. *)

let bs = [| 0x00; 0x26; 0xbb; 0x14; 0x62; 0xb7; 0xcc; 0x33; 0x58; 0x55; 0x1e; 0xed; 0x08; 0x00; 0x45; 0x00; 0x03; 0x78; 0xf7; 0xac |]
let chout = open_out "testbits"
let _ = Array.iter (fun n -> output_char chout (char_of_int n)) bs
let _ = close_out chout
