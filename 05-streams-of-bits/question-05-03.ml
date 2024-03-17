(** From the texbook. *)

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

let putval_fast o v l =
  if l = 8 then
    begin
      if o.obit = (-1) then flush o;
      if o.obit = 7 then o.output.output_char (char_of_int v)
    end
  else putval o v l



let time f =
  let t1 = Sys.time () in
  let _ = f () in
  let t2 = Sys.time () in
  t2 -. t1

let n = 10_000_000

let time_bit_output func name =
  let chout = open_out name in
  let o = output_of_channel chout in
  let bo = output_bits_of_output o in
  let loop () =
    for _ = 1 to n do
      func bo 97 8  (* 97 = 'a' *)
    done
  in
  let t = time loop in
  flush bo;
  close_out chout;
  t

let t_naive = time_bit_output putval "obits_naive.txt"
let t_fast = time_bit_output putval_fast "obits_fast.txt"
