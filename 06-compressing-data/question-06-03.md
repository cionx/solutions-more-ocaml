# Question 6.3

> What happens if we compress our data as a single line of 1680 bits instead of 21 lines of 80?
> What happens if we try to compress already-compressed data?

---

Compressing the date as a single line reduces the compressed size to 880 bits (from 960 bits).
```ocaml
# compress_string_ccitt (packedstring_of_string input_data) 80 21 |> String.length;;
- : int = 120

# compress_string_ccitt (packedstring_of_string input_data) 1680 1 |> String.length;;
- : int = 110
```

Compressing the compressed data again (treated as a single line) blows the size back up to 1776 bits.
```ocaml
# compress_string_ccitt (compress_string_ccitt (packedstring_of_string input_data) 80 21) 960 1 |> String.length;;
- : int = 222
```
