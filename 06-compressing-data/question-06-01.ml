let rec take n l =
  match n, l with
  | 0, _ | _, [] -> []
  | n, h :: t -> h :: take (n - 1) t

let rec drop n l =
  match n, l with
  | 0, _ | _, [] -> l
  | n, h :: t -> drop (n - 1) t

(** Decoding *)

(** [mklist n x] is the list [[x; x; ...; x]] of length [n]. *)
let mklist n x =
  List.init n (fun _ -> x)

let rec decode l =
  match l with
  | n :: t when 0 <= n && n <= 127 ->
      take (n + 1) t @ decode (drop (n + 1) t)
  | n :: x :: t when 128 < n && n <= 255 ->
      mklist (257 - n) x @ decode t
  | 128 :: _ -> []
  | _ -> failwith "decode: invalid run length"

(** Encoding *)

let get_same l =
  match l with
  | [] -> 0
  | x :: xs ->
      let rec loop count list =
        if count = 128 then 128
      else
        match list with
        | h :: t when h = x -> loop (count + 1) t
        | _ -> count
      in
    loop 1 xs

let get_different l =
  match l with
  | [] -> 0
  | x :: xs ->
      let rec loop count prev list =
        match list with
        | [] -> count
        | h :: t when h = prev -> count - 1
        | h :: t -> loop (count + 1) h t
      in
      loop 1 x xs

let rec encode l =
  match l with
  | [] -> [128]
  | x :: y :: t when x = y ->
      let n = get_same l in
      (257 - n) :: x :: encode (drop n l)
  | _ ->
      let n = get_different l in
      (n - 1) :: (take n l) @ encode (drop n l)



(** Testing *)

let input = [40; 40; 53; 46; 48; 48; 48; 48; 48; 48; 44; 32; 52; 46; 53; 56; 51; 51; 51; 51; 41; 44; 32; 40; 52; 46; 53; 48; 48; 48; 48; 48; 44; 53; 46; 48; 48; 48; 48; 48; 48; 41; 41]
let output = [255; 40; 1; 53; 46; 251; 48; 5; 44; 32; 52; 46; 53; 56; 253; 51; 6; 41; 44; 32; 40; 52; 46; 53; 252; 48; 2; 44; 53; 46; 251; 48; 255; 41; 128]
