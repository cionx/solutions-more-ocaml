(** From the textbook. *)

type input = {
  pos_in : unit -> int;
  seek_in : int -> unit;
  input_char : unit -> char;
  in_channel_length : int;
}



(** For this exercise. *)

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
