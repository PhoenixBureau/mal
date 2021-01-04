import rdstdin, reader

proc read(str: string): string = str

proc eval(ast: string): string = ast

proc print(exp: string): string = exp

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
