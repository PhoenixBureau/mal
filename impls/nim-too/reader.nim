import pegs, types

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



proc read_atom(reader: Reader): MalType =
    result = MalType(kind: mttAtom, atomVal: "")


proc read_list(reader: Reader): MalType =
    result = MalType(kind: mttList, listVal: @[])


proc read_form(reader: Reader): MalType =
    result = MalType(kind: mttList, listVal: @[])
    let token = peek(reader)
    case token[0]
    of '(':
        return read_list(reader)
    else:
        return read_atom(reader)
