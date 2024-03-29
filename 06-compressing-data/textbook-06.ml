(** Input and Output. *)

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

type output = {
  output_char : char -> unit;
  out_channel_length : unit -> int
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



(** Text compression and decompression. *)

let string_of_int_list l =
  let b = Bytes.create (List.length l) in
  List.iteri (fun n x -> Bytes.set b n (char_of_int x)) l;
  Bytes.to_string b

let int_list_of_string s =
  let l = ref [] in
  for x = String.length s - 1 downto 0 do
    l := int_of_char s.[x] :: !l
  done;
  !l

let output_of_buffer b =
  {
    output_char = Buffer.add_char b;
    out_channel_length = (fun () -> Buffer.length b)
  }

let process f s =
  let b = Buffer.create (String.length s) in
  f (input_of_string s) (output_of_buffer b);
  Buffer.contents b

exception EOD

let decompress i o =
  try
    while true do
      match int_of_char (i.input_char ()) with
      | x when x >= 0 && x <= 127 ->
        for p = 1 to x + 1 do o.output_char (i.input_char ()) done
      | x when x > 128 && x <= 255 ->
        let c = i.input_char () in
        for p = 1 to 257 - x do o.output_char c done
      | _ -> raise EOD
    done
  with
    EOD -> ()

let decompress_string = process decompress

let get_same i =
  let rec getcount ch c =
    if c = 128 then 128 else
      try
        if i.input_char () = ch
        then getcount ch (c + 1)
        else (rewind i; c)
      with
        End_of_file -> c
  in
    let ch = i.input_char () in
    (ch, getcount ch 1)

let get_different i =
  let rec getdiffinner a c =
    if c = 128 then List.rev a
    else
      try
        let ch' = i.input_char () in
        if ch' <> List.hd a
        then getdiffinner (ch' :: a) (c + 1)
        else (rewind i; rewind i; List.rev (List.tl a))
      with
        End_of_file -> List.rev a
  in
  getdiffinner [i.input_char ()] 1

let compress i o =
  try
    while true do
      match get_same i with
      | (_, 1) ->
        rewind i;
        let cs = get_different i in
        o.output_char (char_of_int (List.length cs - 1));
        List.iter o.output_char cs
      | (b, c) ->
        o.output_char (char_of_int (257 - c));
        o.output_char b
    done
  with
    End_of_file -> o.output_char (char_of_int 128)

let compress_string = process compress

let example = "((5.000000, 4.583333), (4.500000,5.000000))"



(** Fax compression. *)

let input_data =
  "00000000000000000000000000000000000000000000000000000000000000000000000000000000\
   00000000000000000000000000000000000000000000000000000000000000000000000001000000\
   00000000111111110000000000011111111100000000000000000000000000000000000111100000\
   00000011000000011100000001110000001110000000000000000000000000000000000011000000\
   00000110000000001110000011000000000110000000000000000000000000000000000011000000\
   00001110000000000111000111000000000000000000000000000000000000000000000011000000\
   00001100000000000111000110000000000000000000000000000000000000000000000011000000\
   00001100000000000011001110000000000000000011100000000100111000011100000011000000\
   00011100000000000011001110000000000000001111111000111111111101111110000001000000\
   00011100000000000011101100000000000000001000011000001110001111000111000001000000\
   00011100000000000011101100000000000000000000011000001100000110000011000001000000\
   00011100000000000011001110000000000000000000011000001100000110000011000001000000\
   00001100000000000011001110000000000000000111011000001100000110000011000001000000\
   00001110000000000011000110000000000000011100011000001100000110000011000001000000\
   00001110000000000110000111000000000000011000011000001100000110000011000011000000\
   00000111000000000110000011100000000000011000011000001100000110000011000011100000\
   00000011100000001100000001110000000010010001110000011000001100000110000111000000\
   00000011111111100000000001111111111000111110111000111100011110000111001111100000\
   00000000011100000000000000001111000000001000000000000000000000000000000000000000\
   00000000000000000000000000000000000000000000000000000000000000000000000000000000\
   00000000000000000000000000000000000000000000000000000000000000000000000000000000"

let packedstring_of_string s =
  let b = Buffer.create ((String.length s / 8) + 1) in
  let o = output_bits_of_output (output_of_buffer b) in
  for x = 0 to String.length s - 1 do
    putbit o (if s.[x] = '1' then 1 else 0)
  done;
  flush o;
  Buffer.contents b

let getbitint ibits =
  if getbit ibits then 1 else 0

let print_packedstring w s =
  let ibits = input_bits_of_input (input_of_string s) in
  try
    while true do
      for column = 1 to w do print_int (getbitint ibits) done;
      print_newline ()
    done
  with
    End_of_file -> ()

let white_terminating_codes =
  [|[0; 0; 1; 1; 0; 1; 0; 1]; 
    [0; 0; 0; 1; 1; 1];
    [0; 1; 1; 1];
    [1; 0; 0; 0];
    [1; 0; 1; 1];
    [1; 1; 0; 0];
    [1; 1; 1; 0];
    [1; 1; 1; 1];
    [1; 0; 0; 1; 1];
    [1; 0; 1; 0; 0];
    [0; 0; 1; 1; 1];
    [0; 1; 0; 0; 0];
    [0; 0; 1; 0; 0; 0];
    [0; 0; 0; 0; 1; 1];
    [1; 1; 0; 1; 0; 0];
    [1; 1; 0; 1; 0; 1];
    [1; 0; 1; 0; 1; 0];
    [1; 0; 1; 0; 1; 1];
    [0; 1; 0; 0; 1; 1; 1];
    [0; 0; 0; 1; 1; 0; 0];
    [0; 0; 0; 1; 0; 0; 0];
    [0; 0; 1; 0; 1; 1; 1];
    [0; 0; 0; 0; 0; 1; 1];
    [0; 0; 0; 0; 1; 0; 0];
    [0; 1; 0; 1; 0; 0; 0];
    [0; 1; 0; 1; 0; 1; 1];
    [0; 0; 1; 0; 0; 1; 1];
    [0; 1; 0; 0; 1; 0; 0];
    [0; 0; 1; 1; 0; 0; 0];
    [0; 0; 0; 0; 0; 0; 1; 0];
    [0; 0; 0; 0; 0; 0; 1; 1];
    [0; 0; 0; 1; 1; 0; 1; 0];
    [0; 0; 0; 1; 1; 0; 1; 1];
    [0; 0; 0; 1; 0; 0; 1; 0];
    [0; 0; 0; 1; 0; 0; 1; 1];
    [0; 0; 0; 1; 0; 1; 0; 0];
    [0; 0; 0; 1; 0; 1; 0; 1];
    [0; 0; 0; 1; 0; 1; 1; 0];
    [0; 0; 0; 1; 0; 1; 1; 1];
    [0; 0; 1; 0; 1; 0; 0; 0];
    [0; 0; 1; 0; 1; 0; 0; 1];
    [0; 0; 1; 0; 1; 0; 1; 0];
    [0; 0; 1; 0; 1; 0; 1; 1];
    [0; 0; 1; 0; 1; 1; 0; 0];
    [0; 0; 1; 0; 1; 1; 0; 1];
    [0; 0; 0; 0; 0; 1; 0; 0];
    [0; 0; 0; 0; 0; 1; 0; 1];
    [0; 0; 0; 0; 1; 0; 1; 0];
    [0; 0; 0; 0; 1; 0; 1; 1];
    [0; 1; 0; 1; 0; 0; 1; 0];
    [0; 1; 0; 1; 0; 0; 1; 1];
    [0; 1; 0; 1; 0; 1; 0; 0];
    [0; 1; 0; 1; 0; 1; 0; 1];
    [0; 0; 1; 0; 0; 1; 0; 0];
    [0; 0; 1; 0; 0; 1; 0; 1];
    [0; 1; 0; 1; 1; 0; 0; 0];
    [0; 1; 0; 1; 1; 0; 0; 1];
    [0; 1; 0; 1; 1; 0; 1; 0];
    [0; 1; 0; 1; 1; 0; 1; 1];
    [0; 1; 0; 0; 1; 0; 1; 0];
    [0; 1; 0; 0; 1; 0; 1; 1];
    [0; 0; 1; 1; 0; 0; 1; 0];
    [0; 0; 1; 1; 0; 0; 1; 1];
    [0; 0; 1; 1; 0; 1; 0; 0]|]

let black_terminating_codes =
  [|[0; 0; 0; 0; 1; 1; 0; 1; 1; 1];
    [0; 1; 0]; 
    [1; 1];
    [1; 0];
    [0; 1; 1];
    [0; 0; 1; 1];
    [0; 0; 1; 0];
    [0; 0; 0; 1; 1];
    [0; 0; 0; 1; 0; 1];
    [0; 0; 0; 1; 0; 0];
    [0; 0; 0; 0; 1; 0; 0];
    [0; 0; 0; 0; 1; 0; 1];
    [0; 0; 0; 0; 1; 1; 1];
    [0; 0; 0; 0; 0; 1; 0; 0];
    [0; 0; 0; 0; 0; 1; 1; 1];
    [0; 0; 0; 0; 1; 1; 0; 0; 0];
    [0; 0; 0; 0; 0; 1; 0; 1; 1; 1];
    [0; 0; 0; 0; 0; 1; 1; 0; 0; 0];
    [0; 0; 0; 0; 0; 0; 1; 0; 0; 0];
    [0; 0; 0; 0; 1; 1; 0; 0; 1; 1; 1];
    [0; 0; 0; 0; 1; 1; 0; 1; 0; 0; 0];
    [0; 0; 0; 0; 1; 1; 0; 1; 1; 0; 0];
    [0; 0; 0; 0; 0; 1; 1; 0; 1; 1; 1];
    [0; 0; 0; 0; 0; 1; 0; 1; 0; 0; 0];
    [0; 0; 0; 0; 0; 0; 1; 0; 1; 1; 1];
    [0; 0; 0; 0; 0; 0; 1; 1; 0; 0; 0];
    [0; 0; 0; 0; 1; 1; 0; 0; 1; 0; 1; 0];
    [0; 0; 0; 0; 1; 1; 0; 0; 1; 0; 1; 1];
    [0; 0; 0; 0; 1; 1; 0; 0; 1; 1; 0; 0];
    [0; 0; 0; 0; 1; 1; 0; 0; 1; 1; 0; 1];
    [0; 0; 0; 0; 0; 1; 1; 0; 1; 0; 0; 0];
    [0; 0; 0; 0; 0; 1; 1; 0; 1; 0; 0; 1];
    [0; 0; 0; 0; 0; 1; 1; 0; 1; 0; 1; 0];
    [0; 0; 0; 0; 0; 1; 1; 0; 1; 0; 1; 1];
    [0; 0; 0; 0; 1; 1; 0; 1; 0; 0; 1; 0];
    [0; 0; 0; 0; 1; 1; 0; 1; 0; 0; 1; 1];
    [0; 0; 0; 0; 1; 1; 0; 1; 0; 1; 0; 0];
    [0; 0; 0; 0; 1; 1; 0; 1; 0; 1; 0; 1];
    [0; 0; 0; 0; 1; 1; 0; 1; 0; 1; 1; 0];
    [0; 0; 0; 0; 1; 1; 0; 1; 0; 1; 1; 1];
    [0; 0; 0; 0; 0; 1; 1; 0; 1; 1; 0; 0];
    [0; 0; 0; 0; 0; 1; 1; 0; 1; 1; 0; 1];
    [0; 0; 0; 0; 1; 1; 0; 1; 1; 0; 1; 0];
    [0; 0; 0; 0; 1; 1; 0; 1; 1; 0; 1; 1];
    [0; 0; 0; 0; 0; 1; 0; 1; 0; 1; 0; 0];
    [0; 0; 0; 0; 0; 1; 0; 1; 0; 1; 0; 1];
    [0; 0; 0; 0; 0; 1; 0; 1; 0; 1; 1; 0];
    [0; 0; 0; 0; 0; 1; 0; 1; 0; 1; 1; 1];
    [0; 0; 0; 0; 0; 1; 1; 0; 0; 1; 0; 0];
    [0; 0; 0; 0; 0; 1; 1; 0; 0; 1; 0; 1];
    [0; 0; 0; 0; 0; 1; 0; 1; 0; 0; 1; 0];
    [0; 0; 0; 0; 0; 1; 0; 1; 0; 0; 1; 1];
    [0; 0; 0; 0; 0; 0; 1; 0; 0; 1; 0; 0];
    [0; 0; 0; 0; 0; 0; 1; 1; 0; 1; 1; 1];
    [0; 0; 0; 0; 0; 0; 1; 1; 1; 0; 0; 0];
    [0; 0; 0; 0; 0; 0; 1; 0; 0; 1; 1; 1];
    [0; 0; 0; 0; 0; 0; 1; 0; 1; 0; 0; 0];
    [0; 0; 0; 0; 0; 1; 0; 1; 1; 0; 0; 0];
    [0; 0; 0; 0; 0; 1; 0; 1; 1; 0; 0; 1];
    [0; 0; 0; 0; 0; 0; 1; 0; 1; 0; 1; 1];
    [0; 0; 0; 0; 0; 0; 1; 0; 1; 1; 0; 0];
    [0; 0; 0; 0; 0; 1; 0; 1; 1; 0; 1; 0];
    [0; 0; 0; 0; 0; 1; 1; 0; 0; 1; 1; 0];
    [0; 0; 0; 0; 0; 1; 1; 0; 0; 1; 1; 1]|]

let white_make_up_codes =
  [|[1; 1; 0; 1; 1];
    [1; 0; 0; 1; 0];
    [0; 1; 0; 1; 1; 1];
    [0; 1; 1; 0; 1; 1; 1];
    [0; 0; 1; 1; 0; 1; 1; 0];
    [0; 0; 1; 1; 0; 1; 1; 1];
    [0; 1; 1; 0; 0; 1; 0; 0];
    [0; 1; 1; 0; 0; 1; 0; 1];
    [0; 1; 1; 0; 1; 0; 0; 0];
    [0; 1; 1; 0; 0; 1; 1; 1];
    [0; 1; 1; 0; 0; 1; 1; 0; 0];
    [0; 1; 1; 0; 0; 1; 1; 0; 1];
    [0; 1; 1; 0; 1; 0; 0; 1; 0];
    [0; 1; 1; 0; 1; 0; 0; 1; 1];
    [0; 1; 1; 0; 1; 0; 1; 0; 0];
    [0; 1; 1; 0; 1; 0; 1; 0; 1];
    [0; 1; 1; 0; 1; 0; 1; 1; 0];
    [0; 1; 1; 0; 1; 0; 1; 1; 1];
    [0; 1; 1; 0; 1; 1; 0; 0; 0];
    [0; 1; 1; 0; 1; 1; 0; 0; 1];
    [0; 1; 1; 0; 1; 1; 0; 1; 0];
    [0; 1; 1; 0; 1; 1; 0; 1; 1];
    [0; 1; 0; 0; 1; 1; 0; 0; 0];
    [0; 1; 0; 0; 1; 1; 0; 0; 1];
    [0; 1; 0; 0; 1; 1; 0; 1; 0];
    [0; 1; 1; 0; 0; 0];
    [0; 1; 0; 0; 1; 1; 0; 1; 1]|]

let black_make_up_codes =
  [|[0; 0; 0; 0; 0; 0; 1; 1; 1; 1];
    [0; 0; 0; 0; 1; 1; 0; 0; 1; 0; 0; 0];
    [0; 0; 0; 0; 1; 1; 0; 0; 1; 0; 0; 1];
    [0; 0; 0; 0; 0; 1; 0; 1; 1; 0; 1; 1];
    [0; 0; 0; 0; 0; 0; 1; 1; 0; 0; 1; 1];
    [0; 0; 0; 0; 0; 0; 1; 1; 0; 1; 0; 0];
    [0; 0; 0; 0; 0; 0; 1; 1; 0; 1; 0; 1];
    [0; 0; 0; 0; 0; 0; 1; 1; 0; 1; 1; 0; 0];
    [0; 0; 0; 0; 0; 0; 1; 1; 0; 1; 1; 0; 1];
    [0; 0; 0; 0; 0; 0; 1; 0; 0; 1; 0; 1; 0];
    [0; 0; 0; 0; 0; 0; 1; 0; 0; 1; 0; 1; 1];
    [0; 0; 0; 0; 0; 0; 1; 0; 0; 1; 1; 0; 0];
    [0; 0; 0; 0; 0; 0; 1; 0; 0; 1; 1; 0; 1];
    [0; 0; 0; 0; 0; 0; 1; 1; 1; 0; 0; 1; 0];
    [0; 0; 0; 0; 0; 0; 1; 1; 1; 0; 0; 1; 1];
    [0; 0; 0; 0; 0; 0; 1; 1; 1; 0; 1; 0; 0];
    [0; 0; 0; 0; 0; 0; 1; 1; 1; 0; 1; 0; 1];
    [0; 0; 0; 0; 0; 0; 1; 1; 1; 0; 1; 1; 0];
    [0; 0; 0; 0; 0; 0; 1; 1; 1; 0; 1; 1; 1];
    [0; 0; 0; 0; 0; 0; 1; 0; 1; 0; 0; 1; 0];
    [0; 0; 0; 0; 0; 0; 1; 0; 1; 0; 0; 1; 1];
    [0; 0; 0; 0; 0; 0; 1; 0; 1; 0; 1; 0; 0];
    [0; 0; 0; 0; 0; 0; 1; 0; 1; 0; 1; 0; 1];
    [0; 0; 0; 0; 0; 0; 1; 0; 1; 1; 0; 1; 0];
    [0; 0; 0; 0; 0; 0; 1; 0; 1; 1; 0; 1; 1];
    [0; 0; 0; 0; 0; 0; 1; 1; 0; 0; 1; 0; 0];
    [0; 0; 0; 0; 0; 0; 1; 1; 0; 0; 1; 0; 1]|]

let rec code isblack length =
  if length > 1791 || length < 0 then
    invalid_arg "code: bad length"
  else
  if length > 64 then
    let m =
      if isblack
      then black_make_up_codes.(length / 64 - 1)
      else white_make_up_codes.(length / 64 - 1)
    in
    m @ code isblack (length mod 64)
  else
  if isblack
  then black_terminating_codes.(length)
  else white_terminating_codes.(length)

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

let encode_fax i o w h =
  let rec encode_fax_line i o w =
    if w > 0 then
      let n, isblack = read_up_to (peekbit i) i 0 w in
      List.iter (putbit o) (code isblack n);
      encode_fax_line i o (w - n)
  in
  for x = 1 to h do
    if peekbit i then List.iter (putbit o) (code false 0);
    encode_fax_line i o w
  done

let process f s w h =
  let b = Buffer.create (String.length s) in
  let ibits = input_bits_of_input (input_of_string s) in
  let obits = output_bits_of_output (output_of_buffer b) in
  f ibits obits w h;
  flush obits;
  Buffer.contents b

let compress_string_ccitt = process encode_fax



(** Fax decompression. *)

let rec read_white_code i =
  let a = getbitint i in
  let b = getbitint i in
  let c = getbitint i in
  let d = getbitint i in
    match a, b, c, d with
    | 0, 1, 1, 1 -> 2
    | 1, 0, 0, 0 -> 3
    | 1, 0, 1, 1 -> 4
    | 1, 1, 0, 0 -> 5
    | 1, 1, 1, 0 -> 6
    | 1, 1, 1, 1 -> 7
    | _ ->
  let e = getbitint i in
    match a, b, c, d, e with
    | 1, 0, 0, 1, 1 -> 8
    | 1, 0, 1, 0, 0 -> 9
    | 0, 0, 1, 1, 1 -> 10
    | 0, 1, 0, 0, 0 -> 11
    | 1, 1, 0, 1, 1 -> 64 + read_white_code i
    | 1, 0, 0, 1, 0 -> 128 + read_white_code i
    | _ ->
  let f = getbitint i in
    match a, b, c, d, e, f with
    | 0, 0, 0, 1, 1, 1 -> 1
    | 0, 0, 1, 0, 0, 0 -> 12
    | 0, 0, 0, 0, 1, 1 -> 13
    | 1, 1, 0, 1, 0, 0 -> 14
    | 1, 1, 0, 1, 0, 1 -> 15
    | 1, 0, 1, 0, 1, 0 -> 16
    | 1, 0, 1, 0, 1, 1 -> 17
    | 0, 1, 0, 1, 1, 1 -> 192 + read_white_code i
    | 0, 1, 1, 0, 0, 0 -> 1664 + read_white_code i
    | _ ->
  let g = getbitint i in
    match a, b, c, d, e, f, g with
    | 0, 1, 0, 0, 1, 1, 1 -> 18
    | 0, 0, 0, 1, 1, 0, 0 -> 19
    | 0, 0, 0, 1, 0, 0, 0 -> 20
    | 0, 0, 1, 0, 1, 1, 1 -> 21
    | 0, 0, 0, 0, 0, 1, 1 -> 22
    | 0, 0, 0, 0, 1, 0, 0 -> 23
    | 0, 1, 0, 1, 0, 0, 0 -> 24
    | 0, 1, 0, 1, 0, 1, 1 -> 25
    | 0, 0, 1, 0, 0, 1, 1 -> 26
    | 0, 1, 0, 0, 1, 0, 0 -> 27
    | 0, 0, 1, 1, 0, 0, 0 -> 28
    | 0, 1, 1, 0, 1, 1, 1 -> 256 + read_white_code i
    | _ ->
  let h = getbitint i in
    match a, b, c, d, e, f, g, h with
    | 0, 0, 1, 1, 0, 1, 0, 1 -> 0
    | 0, 0, 0, 0, 0, 0, 1, 0 -> 29
    | 0, 0, 0, 0, 0, 0, 1, 1 -> 30
    | 0, 0, 0, 1, 1, 0, 1, 0 -> 31
    | 0, 0, 0, 1, 1, 0, 1, 1 -> 32
    | 0, 0, 0, 1, 0, 0, 1, 0 -> 33
    | 0, 0, 0, 1, 0, 0, 1, 1 -> 34
    | 0, 0, 0, 1, 0, 1, 0, 0 -> 35
    | 0, 0, 0, 1, 0, 1, 0, 1 -> 36
    | 0, 0, 0, 1, 0, 1, 1, 0 -> 37
    | 0, 0, 0, 1, 0, 1, 1, 1 -> 38
    | 0, 0, 1, 0, 1, 0, 0, 0 -> 39
    | 0, 0, 1, 0, 1, 0, 0, 1 -> 40
    | 0, 0, 1, 0, 1, 0, 1, 0 -> 41
    | 0, 0, 1, 0, 1, 0, 1, 1 -> 42
    | 0, 0, 1, 0, 1, 1, 0, 0 -> 43
    | 0, 0, 1, 0, 1, 1, 0, 1 -> 44
    | 0, 0, 0, 0, 0, 1, 0, 0 -> 45
    | 0, 0, 0, 0, 0, 1, 0, 1 -> 46
    | 0, 0, 0, 0, 1, 0, 1, 0 -> 47
    | 0, 0, 0, 0, 1, 0, 1, 1 -> 48
    | 0, 1, 0, 1, 0, 0, 1, 0 -> 49
    | 0, 1, 0, 1, 0, 0, 1, 1 -> 50
    | 0, 1, 0, 1, 0, 1, 0, 0 -> 51
    | 0, 1, 0, 1, 0, 1, 0, 1 -> 52
    | 0, 0, 1, 0, 0, 1, 0, 0 -> 53
    | 0, 0, 1, 0, 0, 1, 0, 1 -> 54
    | 0, 1, 0, 1, 1, 0, 0, 0 -> 55
    | 0, 1, 0, 1, 1, 0, 0, 1 -> 56
    | 0, 1, 0, 1, 1, 0, 1, 0 -> 57
    | 0, 1, 0, 1, 1, 0, 1, 1 -> 58
    | 0, 1, 0, 0, 1, 0, 1, 0 -> 59
    | 0, 1, 0, 0, 1, 0, 1, 1 -> 60
    | 0, 0, 1, 1, 0, 0, 1, 0 -> 61
    | 0, 0, 1, 1, 0, 0, 1, 1 -> 62
    | 0, 0, 1, 1, 0, 1, 0, 0 -> 63
    | 0, 0, 1, 1, 0, 1, 1, 0 -> 320 + read_white_code i
    | 0, 0, 1, 1, 0, 1, 1, 1 -> 384 + read_white_code i
    | 0, 1, 1, 0, 0, 1, 0, 0 -> 448 + read_white_code i
    | 0, 1, 1, 0, 0, 1, 0, 1 -> 512 + read_white_code i
    | 0, 1, 1, 0, 1, 0, 0, 0 -> 576 + read_white_code i
    | 0, 1, 1, 0, 0, 1, 1, 1 -> 640 + read_white_code i
    | _ ->
  let j = getbitint i in
    match a, b, c, d, e, f, g, h, j with
    | 0, 1, 1, 0, 0, 1, 1, 0, 0 -> 704 + read_white_code i
    | 0, 1, 1, 0, 0, 1, 1, 0, 1 -> 768 + read_white_code i
    | 0, 1, 1, 0, 1, 0, 0, 1, 0 -> 832 + read_white_code i
    | 0, 1, 1, 0, 1, 0, 0, 1, 1 -> 896 + read_white_code i
    | 0, 1, 1, 0, 1, 0, 1, 0, 0 -> 960 + read_white_code i
    | 0, 1, 1, 0, 1, 0, 1, 0, 1 -> 1024 + read_white_code i
    | 0, 1, 1, 0, 1, 0, 1, 1, 0 -> 1088 + read_white_code i
    | 0, 1, 1, 0, 1, 0, 1, 1, 1 -> 1152 + read_white_code i
    | 0, 1, 1, 0, 1, 1, 0, 0, 0 -> 1216 + read_white_code i
    | 0, 1, 1, 0, 1, 1, 0, 0, 1 -> 1280 + read_white_code i
    | 0, 1, 1, 0, 1, 1, 0, 1, 0 -> 1344 + read_white_code i
    | 0, 1, 1, 0, 1, 1, 0, 1, 1 -> 1408 + read_white_code i
    | 0, 1, 0, 0, 1, 1, 0, 0, 0 -> 1472 + read_white_code i
    | 0, 1, 0, 0, 1, 1, 0, 0, 1 -> 1536 + read_white_code i
    | 0, 1, 0, 0, 1, 1, 0, 1, 0 -> 1600 + read_white_code i
    | 0, 1, 0, 0, 1, 1, 0, 1, 1 -> 1728 + read_white_code i
    | _ -> raise (Failure "bad white code")

let rec read_black_code i =
  let a = getbitint i in
  let b = getbitint i in
    match a, b with
    | 1, 1 -> 2
    | 1, 0 -> 3
    | _ ->
  let c = getbitint i in
    match a, b, c with
    | 0, 1, 0 -> 1
    | 0, 1, 1 -> 4
    | _ ->
  let d = getbitint i in
    match a, b, c, d with
    | 0, 0, 1, 1 -> 5
    | 0, 0, 1, 0 -> 6
    | _ ->
  let e = getbitint i in
    match a, b, c, d, e with
    | 0, 0, 0, 1, 1 -> 7
    | _ ->
  let f = getbitint i in
    match a, b, c, d, e, f with
    | 0, 0, 0, 1, 0, 1 -> 8
    | 0, 0, 0, 1, 0, 0 -> 9
    | _ ->
  let g = getbitint i in
    match a, b, c, d, e, f, g with
    | 0, 0, 0, 0, 1, 0, 0 -> 10
    | 0, 0, 0, 0, 1, 0, 1 -> 11
    | 0, 0, 0, 0, 1, 1, 1 -> 12
    | _ ->
  let h = getbitint i in
    match a, b, c, d, e, f, g, h with
    | 0, 0, 0, 0, 0, 1, 0, 0 -> 13
    | 0, 0, 0, 0, 0, 1, 1, 1 -> 14
    | _ ->
  let j = getbitint i in
    match a, b, c, d, e, f, g, h, j with
    | 0, 0, 0, 0, 1, 1, 0, 0, 0 -> 15
    | _ ->
  let k = getbitint i in
    match a, b, c, d, e, f, g, h, j, k with
    | 0, 0, 0, 0, 1, 1, 0, 1, 1, 1 -> 0
    | 0, 0, 0, 0, 0, 1, 0, 1, 1, 1 -> 16
    | 0, 0, 0, 0, 0, 1, 1, 0, 0, 0 -> 17
    | 0, 0, 0, 0, 0, 0, 1, 0, 0, 0 -> 18
    | 0, 0, 0, 0, 0, 0, 1, 1, 1, 1 -> 64 + read_black_code i
    | _ ->
  let l = getbitint i in
    match a, b, c, d, e, f, g, h, j, k, l with
    | 0, 0, 0, 0, 1, 1, 0, 0, 1, 1, 1 -> 19
    | 0, 0, 0, 0, 1, 1, 0, 1, 0, 0, 0 -> 20
    | 0, 0, 0, 0, 1, 1, 0, 1, 1, 0, 0 -> 21
    | 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 1 -> 22
    | 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0 -> 23
    | 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1 -> 24
    | 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0 -> 25
    | _ ->
  let m = getbitint i in
    match a, b, c, d, e, f, g, h, j, k, l, m with
    | 0, 0, 0, 0, 1, 1, 0, 0, 1, 0, 1, 0 -> 26
    | 0, 0, 0, 0, 1, 1, 0, 0, 1, 0, 1, 1 -> 27
    | 0, 0, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0 -> 28
    | 0, 0, 0, 0, 1, 1, 0, 0, 1, 1, 0, 1 -> 29
    | 0, 0, 0, 0, 0, 1, 1, 0, 1, 0, 0, 0 -> 30
    | 0, 0, 0, 0, 0, 1, 1, 0, 1, 0, 0, 1 -> 31
    | 0, 0, 0, 0, 0, 1, 1, 0, 1, 0, 1, 0 -> 32
    | 0, 0, 0, 0, 0, 1, 1, 0, 1, 0, 1, 1 -> 33
    | 0, 0, 0, 0, 1, 1, 0, 1, 0, 0, 1, 0 -> 34
    | 0, 0, 0, 0, 1, 1, 0, 1, 0, 0, 1, 1 -> 35
    | 0, 0, 0, 0, 1, 1, 0, 1, 0, 1, 0, 0 -> 36
    | 0, 0, 0, 0, 1, 1, 0, 1, 0, 1, 0, 1 -> 37
    | 0, 0, 0, 0, 1, 1, 0, 1, 0, 1, 1, 0 -> 38
    | 0, 0, 0, 0, 1, 1, 0, 1, 0, 1, 1, 1 -> 39
    | 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 0, 0 -> 40
    | 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 0, 1 -> 41
    | 0, 0, 0, 0, 1, 1, 0, 1, 1, 0, 1, 0 -> 42
    | 0, 0, 0, 0, 1, 1, 0, 1, 1, 0, 1, 1 -> 43
    | 0, 0, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0 -> 44
    | 0, 0, 0, 0, 0, 1, 0, 1, 0, 1, 0, 1 -> 45
    | 0, 0, 0, 0, 0, 1, 0, 1, 0, 1, 1, 0 -> 46
    | 0, 0, 0, 0, 0, 1, 0, 1, 0, 1, 1, 1 -> 47
    | 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 0, 0 -> 48
    | 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 0, 1 -> 49
    | 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 1, 0 -> 50
    | 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 1, 1 -> 51
    | 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0 -> 52
    | 0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 1 -> 53
    | 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0 -> 54
    | 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 1 -> 55
    | 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0 -> 56
    | 0, 0, 0, 0, 0, 1, 0, 1, 1, 0, 0, 0 -> 57
    | 0, 0, 0, 0, 0, 1, 0, 1, 1, 0, 0, 1 -> 58
    | 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1, 1 -> 59
    | 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 0, 0 -> 60
    | 0, 0, 0, 0, 0, 1, 0, 1, 1, 0, 1, 0 -> 61
    | 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 1, 0 -> 62
    | 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 1, 1 -> 63
    | 0, 0, 0, 0, 1, 1, 0, 0, 1, 0, 0, 0 -> 128 + read_black_code i
    | 0, 0, 0, 0, 1, 1, 0, 0, 1, 0, 0, 1 -> 192 + read_black_code i
    | 0, 0, 0, 0, 0, 1, 0, 1, 1, 0, 1, 1 -> 256 + read_black_code i
    | 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 1 -> 320 + read_black_code i
    | 0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 0, 0 -> 384 + read_black_code i
    | 0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 0, 1 -> 448 + read_black_code i
    | _ ->
  let n = getbitint i in
    match a, b, c, d, e, f, g, h, j, k, l, m, n with
    | 0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 0, 0 -> 512 + read_black_code i
    | 0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 0, 1 -> 576 + read_black_code i
    | 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0 -> 640 + read_black_code i
    | 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 1, 1 -> 704 + read_black_code i
    | 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0 -> 768 + read_black_code i
    | 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 0, 1 -> 832 + read_black_code i
    | 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 1, 0 -> 896 + read_black_code i
    | 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 1, 1 -> 960 + read_black_code i
    | 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 1, 0, 0 -> 1024 + read_black_code i
    | 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 1, 0, 1 -> 1088 + read_black_code i
    | 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 1, 1, 0 -> 1152 + read_black_code i
    | 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 1, 1, 1 -> 1216 + read_black_code i
    | 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 1, 0 -> 1280 + read_black_code i
    | 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 1, 1 -> 1344 + read_black_code i
    | 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0 -> 1408 + read_black_code i
    | 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1, 0, 1 -> 1472 + read_black_code i
    | 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 0, 1, 0 -> 1536 + read_black_code i
    | 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 0, 1, 1 -> 1600 + read_black_code i
    | 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 0, 0 -> 1664 + read_black_code i
    | 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 0, 1 -> 1728 + read_black_code i
    | _ -> raise (Failure "bad black code")

let decode_fax i o w h =
  let lines = ref h in
  let pixels = ref w in
  let iswhite = ref true in
  while !lines > 0 do
    while !pixels > 0 do
      let n = (if !iswhite then read_white_code else read_black_code) i in
      for x = 1 to n do
        putbit o (if !iswhite then 0 else 1)
      done;
      pixels := !pixels - n;
      iswhite := not !iswhite
    done;
    iswhite := true;
    pixels := w;
    lines := !lines - 1
  done

let decompress_string_ccitt = process decode_fax
