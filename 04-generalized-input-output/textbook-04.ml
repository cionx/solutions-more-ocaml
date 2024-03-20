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



let rewind i =
  i.seek_in (i.pos_in () - 1)

let is_non_letter x =
  match x with
  | ' ' | '!' | '(' | ')' | '.' | ',' | ';' | ':' -> true
  | _ -> false

let rec skip_characters i =
  if is_non_letter (i.input_char ())
  then skip_characters i
  else rewind i

let rec collect_characters b i =
  match
    try Some (i.input_char ()) with End_of_file -> None
  with
  | None -> Buffer.contents b
  | Some c ->
    if is_non_letter c
    then Buffer.contents b
    else (Buffer.add_char b c; collect_characters b i)

let read_word i =
  try
    skip_characters i;
    Some (collect_characters (Buffer.create 20) i)
  with
    End_of_file -> None

let rec read_words_inner i a =
  match read_word i with
  | None -> List.rev (List.map String.lowercase_ascii a)
  | Some w -> read_words_inner i (w :: a)

let read_words i =
  read_words_inner i []




type output = {
  output_char : char -> unit;
  out_channel_length : unit -> int
}

let output_of_channel ch =
  {
    output_char = output_char ch;
    out_channel_length = (fun () -> out_channel_length ch);
  }

let output_of_bytes b =
  let pos = ref 0 in
  {
    output_char =
      (fun c ->
        if !pos < Bytes.length b
        then (Bytes.set b !pos c; pos := !pos + 1)
        else raise End_of_file);
    out_channel_length = (fun () -> Bytes.length b);
  }



let output_int_list o l =
  o.output_char '[';
  List.iter
    (fun n ->
      String.iter o.output_char (string_of_int n);
      o.output_char ';';
      o.output_char ' ')
    l;
  o.output_char ']'
