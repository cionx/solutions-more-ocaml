# Question 3.2

> Using functions from the “Time Functions” section of the documentation to the `Unix` module, write a program which, when run, returns a string containing the time and date, for example `"It is 2:45 on Wednesday 8 January 2014"`.

---

We use auxiliary functions:
```ocaml
let string_of_month m =
  match m with
  | 0 -> "January"
  | 1 -> "February"
  | 2 -> "March"
  | 3 -> "April"
  | 4 -> "May"
  | 5 -> "June"
  | 6 -> "July"
  | 7 -> "August"
  | 8 -> "September"
  | 9 -> "October"
  | 10 -> "November"
  | 11 -> "December"
  | _ -> invalid_arg "string_of_month"

let string_of_day d =
  match d with
  | 0 -> "Sunday"
  | 1 -> "Monday"
  | 2 -> "Tuesday"
  | 3 -> "Wednesday"
  | 4 -> "Thursday"
  | 5 -> "Friday"
  | 6 -> "Saturday"
  | _ -> invalid_arg "string_of_day"
```

We can now implement the described function as follows, assuming that the `Unix` module is in scope.[^1]
```ocaml
let string_of_now () =
  let t = Unix.localtime (Unix.time ()) in
  Format.sprintf
    "It is %d:%02d:%02d on %s %d %s %d"
    t.tm_hour
    t.tm_min
    t.tm_sec
    (string_of_day t.tm_wday)
    t.tm_mday
    (string_of_month t.tm_mon)
    (t.tm_year + 1900)
```

[^1]: In utop it can be brought in scope with `#require "unix"`.
