import pegs, strutils, types

type

  Token = string

  Reader = tuple
    tokens : seq[Token]
    position: uint

var p = peg"""

    Token <-  \s * (

    {'~@'} 
    
    /
    
    {[\[\]{}()'`~^@]}

    /

    { "\"" ("\\" . / [^"])* "\"" }

    /

    { ';' .* }

    /

    { (!NonSpecial .)* }
    
    )
    
    NonSpecial <- \s / '[' / ']' / '{' / '}' / '(' / ['] / '"' / '`' / ',' / ';' / ')'
    
    """


proc next(reader: var Reader): Token =
    result = reader.tokens[reader.position]
    inc reader.position

proc peek(reader: Reader): Token =
    reader.tokens[reader.position]


proc tokenize(input: string): seq[Token] =
    result = @[]
    for substr in findAll(input, p):
        result.add(Token(substr))


proc read_form(reader: var Reader): MalType


proc read_atom(reader: var Reader): MalType =
    var tok = next(reader)
    if tok =~ peg"\d+":
        result = MalType(kind: mttInt, intVal: parseInt(tok))
    else:
        result = MalType(kind: mttAtom, atomVal: tok)


proc read_list(reader: var Reader): MalType =
    var items : seq[MalType] = @[]
    discard next(reader)  # Skip the '('.
    while true:
        if peek(reader) == ")":
            discard next(reader)  # Skip the ')'.
            break
        items.add(read_form(reader))
    result = MalType(kind: mttList, listVal: items)


proc read_form(reader: var Reader): MalType =
    case peek(reader)[0]
    of '(':
        return read_list(reader)
    else:
        return read_atom(reader)
