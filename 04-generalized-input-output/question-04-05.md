# Question 4.5

> Write an input type which raises `End_of_file` if it reaches a new line (a `'\n'` character).
> Use this to build a program which reads a line from standard input.

---

We can implement the first part of this exercise as follows:
```ocaml
let line_input_of_channel ch =
  {
    pos_in = (fun () -> pos_in ch);
    seek_in = seek_in ch;
    input_char =
      (fun () ->
        match input_char ch with
        | '\n' -> raise End_of_file
        | c -> c);
    in_channel_length = in_channel_length ch;
  }
```
For the second part of the exercise we can use the following function:
```ocaml
let line_of_line_input i =
  let buf = Buffer.create 80 in
  try
    while true do Buffer.add_char buf (i.input_char ()) done;
    Buffer.contents buf (* to get the correct return type *)
  with
    End_of_file -> Buffer.contents buf
```

On our system we cannot create an `input` from `stdin`, because `in_channel_length stdin` results in an error:
```ocaml
# in_channel_length stdin;;
Exception: Sys_error "Illegal seek".
```
We can therefore not finish this question.
