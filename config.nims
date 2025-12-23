
# Config preset for static musl build (without libraries)
# with options set for size/speed optimization
# source: modified: https://github.com/kaushalmodi/nimy_lisp

from macros import error
from os import `/`, splitfile
from std/enumerate import enumerate

const
  do_optimize = true
  do_optimize_speed = false
  do_optimize_size = true


proc dollar[T](s: T): string =
  result = $s


proc mapconcat[T](s: open_array[T]; sep = " "; op: proc(x: T): string = dollar): string =
  ## Concatenate elements of ``s`` after applying ``op`` to each element.
  ## Separate each element using ``sep``.
  for i, x in s:
    result.add(op(x))
    if i < s.len-1:
      result.add(sep)


# -d:musl
when defined(musl):
  var musl_gcc_path: string
  echo "  [-d:musl] Building a static binary using musl .."
  musl_gcc_path = find_exe("musl-gcc")
  if musl_gcc_path == "":
    error("`musl-gcc` binary was not found in PATH.")
  switch("passL", "-static")
  switch("gcc.exe", musl_gcc_path)
  switch("gcc.linkerexe", musl_gcc_path)
  #switch("d", "strip")  # works only when defined via command line.
  when do_optimize:
    switch("d", "danger")
    switch("passC", "-flto")
    switch("passL", "-flto")
    when do_optimize_size:
      switch("opt", "size")
      #switch("passL", "-s")  # -s: omit the symbol table, not used in favor of -d:strip (defined via command line)
      switch("passL", "-w")   # -w: omit DWARF debugging information
    when do_optimize_speed:
      switch("opt", "speed")


# nim musl foo.nim
task musl, "Builds an optimized static binary using musl":
  ## Usage: nim musl <file1> <file2> ..
  var
    switches: seq[string]
    nim_files: seq[string]
  let
    num_params = param_count()
  # Skip param 0 (nim) and 1 (musl)
  for i in 2 .. num_params:
    if param_str(i)[0] == '-':    # -d:foo or --define:foo
      switches.add(param_str(i))
    else:
      # Non-switch parameters are assumed to be Nim file names.
      nim_files.add(param_str(i))
  if nim_files.len == 0:
    error(["The 'musl' sub-command accepts at least one Nim file name",
           "  Examples: nim musl FILE.nim",
           "            nim musl FILE1.nim FILE2.nim"].mapconcat("\n"))
  for index, file in enumerate(nim_files):
    let
      # Save the binary in the same dir as the nim file
      (dirname, basename, _) = splitfile(file)
      binfile = dirname / basename
      nim_args = ["-d:musl", "c", switches.mapconcat(), file].mapconcat()
    # Build binary
    echo "\nRunning 'nim " & nim_args & "' .."
    self_exec nim_args
    echo "\nCreated binary: " & binfile
    if index+1 == nim_files.len:
      quit()
