(** From the textbook. *)

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



(** For this exercise. *)

let input_string i n =
  let buf = Buffer.create n in
  let rec loop k =
    if k <= 0 then ()
    else try
      Buffer.add_char buf (i.input_char ());
      loop (k - 1)
    with
      End_of_file -> ()
  in
  loop n;
  Buffer.contents buf
