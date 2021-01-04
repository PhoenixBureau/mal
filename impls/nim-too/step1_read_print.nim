import rdstdin, printer, reader, types

proc read(str: string): MalType =
  read_str(str)

proc eval(ast: MalType): MalType = ast

proc print(exp: MalType): string = 
  pr_str(exp)

proc rep(input: string): string =
  print(eval(read(input)))


# Handle Ctrl-C by raising an IOError to break out of the mainloop
# without waiting for the user to press enter.
proc ctrlc() {.noconv.} =
  raise newException(IOError, "Got Ctrl-C, bye!")
setControlCHook(ctrlc)


while true:
  try:
    echo rep(readLineFromStdin("user> "))
  except IOError:
    break
