(** From the textbook. *)

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



(** For this exercise. *)

let getval_32 b n =
  if n <= 0 || n > 32 then invalid_arg "getval32"
  else
    let r = ref 0l in
    for x = n - 1 downto 0 do
      r := Int32.logor !r (Int32.shift_left (if getbit b then 1l else 0l) x)
    done;
    !r



(** For testing. *)

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

let bs = [| 0x00; 0x26; 0xbb; 0x14; 0x62; 0xb7; 0xcc; 0x33; 0x58; 0x55; 0x1e; 0xed; 0x08; 0x00; 0x45; 0x00; 0x03; 0x78; 0xf7; 0xac |]
let chout = open_out "question-05-02.test"
let _ = Array.iter (fun n -> output_char chout (char_of_int n)) bs
let _ = close_out chout

let _ = print_header "question-05-02.test"
(** Compare with the results on pages 29 and 31. *)
