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



(** For this exercise. *)

let line_input_of_channel ch =
  {
    pos_in = (fun () -> pos_in ch);
    seek_in = seek_in ch;
    input_char =
      (fun () ->
        match input_char ch with
        | '\n' -> raise End_of_file
        | c -> c);
    in_channel_length = in_channel_length ch;
  }

let line_of_line_input i =
  let buf = Buffer.create 80 in
  try
    while true do Buffer.add_char buf (i.input_char ()) done;
    Buffer.contents buf (* to get the correct return type *)
  with
    End_of_file -> Buffer.contents buf
