# Question 5.2

> Write the function `getval_32` which can get a value of type `Int32.t` in the same fashion as `getval`.

---

We can write this function as follows:
```ocaml
let getval_32 b n =
  if n <= 0 || n > 32 then invalid_arg "getval32"
  else
    let r = ref 0l in
    for x = n - 1 downto 0 do
      r := Int32.logor !r (Int32.shift_left (if getbit b then 1l else 0l) x)
    done;
    !r
```
