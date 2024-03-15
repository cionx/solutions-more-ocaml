# Question 3.5

> Records are used in the module `Gc` which controls OCaml’s garbage collector (a garbage collector is a system which automatically reclaims space the program has finished with as the program is running).
> Use the data structures and functions in the `Gc` module to write programs which:
> 1. write a summary of the state of the garbage collector to a text file; and
> 2. alter the verbosity of the garbage collector as defined in the control record.

---

### 1.

The following function prints the current state of the garbage collector to an output channel:
```ocaml
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
```
We use this function to write the current state of the garbage collector to a file:
```ocaml
let save_stats filename =
  let chout = open_out filename in
  write_stats chout;
  close_out chout
```

### 2.

We can change the verbosity of the garbage collector with
```ocaml
Gc.set { (Gc.get ()) with verbose = newvalue }
```
where the value `newvalue` is a sum of the following values (taken from the `Gc` documentation):

|  value  | description                                                |
| :-----: | :----------------------------------------------------------|
| `0x001` | Start and end of major GC cycle.                           |
| `0x002` | Minor collection and major GC slice.                       |
| `0x004` | Growing and shrinking of the heap.                         |
| `0x008` | Resizing of stacks and memory manager tables.              |
| `0x010` | Heap compaction.                                           |
| `0x020` | Change of GC parameters.                                   |
| `0x040` | Computation of major GC slice size.                        |
| `0x080` | Calling of finalisation functions.                         |
| `0x100` | Bytecode executable and shared library search at start-up. |
| `0x200` | Computation of compaction-triggering condition.            |
| `0x400` | Output GC statistics at program exit. Default: 0.          |

For example, to output the state of the garbage collector on program exit, we do the following:
```ocaml
Gc.set { (Gc.get ()) with verbose = 0x400 }
```
