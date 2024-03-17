# Question 5.1

> Specialize the function `getval` so that reading 8 bits at a time when the input is aligned is optimized.
> Benchmark this function against the naive one.

---

We can implement the described function as a wrapper around `getval`:
```ocaml
let getval_fast b n =
  if n = 8 && b.bit = 0
  then int_of_char (b.input.input_char ())
  else getval b n
```

We benchmark the functions as follows:
```ocaml
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
```
We get the following result:
```text
val t_naive : float = 10.128554
val t_fast : float = 1.1569199999999995
```
The running times differ by a factor of roughly 9.
