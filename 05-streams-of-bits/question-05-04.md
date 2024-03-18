# Question 5.4

> Write the function `putval_32` which can put a value of type `Int32.t` in the same fashion as `putval.`

---

We can write the described function as follows:
```ocaml
let putval_32 o v l =
  for x = l - 1 downto 0 do
    let bit = Int32.logand v (Int32.shift_left 1l x) > 0l in
    putbit o (if bit then 1 else 0)
  done
```

We tested this function with `output_header` and `print_header`, and we get back the original values.

**Remark.**
It should be noted that the header written by `output_header` is _not_ the header from page 29.
The difference lies in the fields “Data offset” and “Reserved”.

- The header in page 29 uses the two bytes `08 00` for the fields “data offset”, “reserved” and the following 6 flags.
  The number `0x08` is `8`, which is `0b00001000`, and `0x00` is `0`, which is `0b00000000`.
  We have therefore the bits `00001000 00000000`, and thus `0000` for “data offset”, `100000` for “reserved” and `0` for each of the six flags

- The function `output_header` uses `5` for “data offset”, `0` for “reserved”, and `0` for each of the six flags.
  In binary, these are `0101`, `000000` and `0` six times.
  We have therefore the bits `01010000 00000000`, which corresponds in hexadecimal to `50 00`.

We can verify these results with the command line tool `xxd`:
```text
$ xxd -g 1 -c 20 question-05-02.test
00000000: 00 26 bb 14 62 b7 cc 33 58 55 1e ed 08 00 45 00 03 78 f7 ac  .&..b..3XU....E..x..

$ xxd -g 1 -c 20 question-05-04.test
00000000: 00 26 bb 14 62 b7 cc 33 58 55 1e ed 50 00 45 00 03 78 f7 ac  .&..b..3XU..P.E..x..`
```
We see that the two files differ only in one byte, where we have `08` vs `50`.
