import pegs

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
