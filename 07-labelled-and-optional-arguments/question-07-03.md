# Question 7.3

> Build labelled versions of functions from the `Buffer` module, choosing which functions and arguments to label as appropriate.

---

For simplicity, we label all non-buffer arguments.
This leads to the following labelled functions:
```ocaml
let sub b ~off ~len =
  Buffer.sub b off len

let blit ~src ~srcoff ~dst ~dstoff ~len =
  Buffer.blit src srcoff dst dstoff len

let nth b ~n =
  Buffer.nth b n

let output_buffer ~oc b =
  Buffer.output_buffer oc b

let truncate b ~len =
  Buffer.truncate b len

(** Appending *)

let add_char b ~c =
  Buffer.add_char b c

let add_utf_8_uchar b ~u =
  Buffer.add_utf_8_uchar b u

let add_utf_16le_uchar b ~u =
  Buffer.add_utf_16le_uchar b u

let add_utf_16be_uchar b ~u =
  Buffer.add_utf_16be_uchar b u

let add_string b ~s =
  Buffer.add_string b s

let add_bytes b ~s =
  Buffer.add_bytes b s

let add_substring b s ~off ~len =
  Buffer.add_substring b s off len

let add_subbytes b s ~off ~len =
  Buffer.add_subbytes b s off len

let add_substitute b ~f ~s =
  Buffer.add_substitute b f s

let add_channel b ~ic ~n =
  Buffer.add_channel b ic n

(** Binary encoding of integers *)

let add_uint8 b ~i =
  Buffer.add_uint8 b i

let add_int8 b ~i =
  Buffer.add_int8 b i

let add_uint16_ne b ~i =
  Buffer.add_uint16_ne b i

let add_uint16_be b ~i =
  Buffer.add_uint16_be b i

let add_uint16_le b ~i =
  Buffer.add_uint16_le b i

let add_int16_ne b ~i =
  Buffer.add_int16_ne b i

let add_int16_le b ~i =
  Buffer.add_int16_le b i

let add_int16_be b ~i =
  Buffer.add_int16_be b i

let add_int32_ne b ~i =
  Buffer.add_int32_ne b i

let add_int32_le b ~i =
  Buffer.add_int32_le b i

let add_int32_be b ~i =
  Buffer.add_int32_be b i

let add_int64_ne b ~i =
  Buffer.add_int64_ne b i

let add_int64_le b ~i =
  Buffer.add_int64_le b i

let add_int64_be b ~i =
  Buffer.add_int64_be b i
```
