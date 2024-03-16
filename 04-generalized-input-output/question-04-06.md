# Question 4.6

> Write a function to build an output from a `Buffer.t.`
> Show how this can be used to retrieve a final string after output is finished.

---

We can build an output from a buffer as follows:
```ocaml
let output_of_buffer b =
  {
    output_char = Buffer.add_char b;
    out_channel_length = (fun () -> Buffer.length b)
  }
```
After output is finished we can retrieve the final string with `Buffer.contents b`.
