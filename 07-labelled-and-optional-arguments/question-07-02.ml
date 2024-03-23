type length = Len of int
type index = Ind of int

let fill arr (Ind s) (Len l) v =
  for x = s to s + l - 1 do arr.(x) <- v done
