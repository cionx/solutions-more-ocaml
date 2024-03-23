# Question 6.4

> Write a function which, given input data, will calculate a histogram of the frequencies of different runs of white and black.
> This could be used to build custom codes for each image, improving compression.

---

### Main code

The following function counts the number of white runs and black runs of different lengths:
```ocaml
let count_runs i w h =
  let counter_white = Array.make (w + 1) 0 in
  let counter_black = Array.make (w + 1) 0 in
  let rec process_line w =
    if w > 0 then begin
      let (n, isblack) = read_up_to (peekbit i) i 0 w in
      if isblack then
        counter_black.(n) <- counter_black.(n) + 1
      else
        counter_white.(n) <- counter_white.(n) + 1;
      process_line (w - n)
      end
  in
  for _ = 1 to h do
    if peekbit i then counter_white.(0) <- counter_white.(0) + 1;
    process_line w
  done;
  (counter_white, counter_black)
```
These data are then printed with the following function:
```ocaml
let print_histogram i w h =
  let print_array name arr =
    print_string name;
    print_string "\n";
    for i = 0 to w do
      if arr.(i) > 0 then begin
        print_string "\t";
        print_int i;
        print_string " - ";
        print_int arr.(i);
        print_string "\n"
        end
    done
  in
  let counter_white, counter_black = count_runs i w h in
  print_array "white" counter_white;
  print_string "\n";
  print_array "black" counter_black
```



### Testing

We test our functions as follows:
```ocaml
let input_data =
  "00000000\
   11111111\
   00001111\
   11110000\
   00110011\
   11001100\
   01010101\
   10101010"
(* expected histogram:
    white
      0 - 4
      1 - 8
      2 - 4
      4 - 2
      8 - 1
    black
      1 - 8
      2 - 4
      4 - 2
      8 - 1 *)

let packed_data = packedstring_of_string input_data
let i = input_bits_of_input (input_of_string packed_data)

let () = print_histogram i 8 8
```
The output is correct:
```text
white
	0 - 4
	1 - 8
	2 - 4
	4 - 2
	8 - 1

black
	1 - 8
	2 - 4
	4 - 2
	8 - 1
```
