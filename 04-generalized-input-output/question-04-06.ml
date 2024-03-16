type output = {
  output_char : char -> unit;
  out_channel_length : unit -> int
}

let output_of_buffer b =
  {
    output_char = (fun c -> Buffer.add_char b c);
    out_channel_length = (fun () -> Buffer.length b)
  }
