let write_stats ch =
  let stats = Gc.stat () in
  Printf.fprintf ch
    "minor words: %.0f\n\
     major words: %.0f\n\
     minor collections: %d\n\
     major collections: %d\n\
     heap words: %d\n\
     heap chunks: %d\n\
     live words: %d\n\
     live blocks: %d\n\
     free words: %d\n\
     free blocks: %d\n\
     largest free: %d\n\
     fragments: %d\n\
     compactions: %d\n\
     top heap words: %d\n\
     stack size: %d\n\
     forced major collections: %d\n"
    stats.minor_words
    stats.major_words
    stats.minor_collections
    stats.major_collections
    stats.heap_words
    stats.heap_chunks
    stats.live_words
    stats.live_blocks
    stats.free_words
    stats.free_blocks
    stats.largest_free
    stats.fragments
    stats.compactions
    stats.top_heap_words
    stats.stack_size
    stats.forced_major_collections

let save_stats filename =
  let chout = open_out filename in
  write_stats chout;
  close_out chout
