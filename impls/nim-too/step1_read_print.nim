import rdstdin, strutils, printer1, reader1, types1

proc read(tokens: seq[Token]): MalType =
  read_tokens(tokens)

proc eval(ast: MalType): MalType = ast

proc print(exp: MalType): string = 
  pr_str(exp)

proc rep(input: string): string =
  if isEmptyOrWhitespace(input):
    return ""
  var tokens: seq[Token] = tokenize(input)
  if tokens.len == 0:
    return ""
  print(eval(read(tokens)))


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
