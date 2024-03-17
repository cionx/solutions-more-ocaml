(** From the textbook. *)

type input = {
  pos_in : unit -> int;
  seek_in : int -> unit;
  input_char : unit -> char;
  in_channel_length : int;
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

let getval b n =
  if n <= 0 || n > 31 then invalid_arg "getval"
  else
    let r = ref 0 in
    for x = n - 1 downto 0 do
      r := !r lor ((if getbit b then 1 else 0) lsl x)
    done;
    !r



(** For this exercise. *)

let getval_fast b n =
  if n = 8 && b.bit = 0
  then int_of_char (b.input.input_char ())
  else getval b n



let time f =
  let t1 = Sys.time () in
  let _ = f () in
  let t2 = Sys.time () in
  t2 -. t1

let n = 10_000_000
let arr = Array.make n 'a'
let i = input_of_array arr
let b = input_bits_of_input i

let test_fun f () =
  i.seek_in 0;
  for i = 1 to n do
    ignore(f b 8)
  done

let t_naive = time (test_fun getval)
let t_fast = time (test_fun getval_fast)
