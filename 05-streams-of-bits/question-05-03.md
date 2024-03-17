# Question 5.3

> Specialize the function `putval` so that writing 8 bits at a time when the output is aligned is optimized.
> Benchmark this function against the naive one.

---

We write the described function as a wrapper around `putval`:
```ocaml
let putval_fast o v l =
  if l = 8 then
    begin
      if o.obit = (-1) then flush o;
      if o.obit = 7 then o.output.output_char (char_of_int v)
    end
  else putval o v l
```

We benchmark the functions `putval` and `putval_fast` as follows:
```ocaml
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
```
We get the following results:
```text
val t_naive : float = 9.709699
val t_fast : float = 1.31220700000000079
```
The function `putval_fast` is faster by a factor of roughly 7.4.
