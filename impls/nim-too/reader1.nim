import pegs, strutils, types1

type

  Token* = string

  Reader = tuple
    tokens : seq[Token]
    position: int
    eof: bool

var p = peg"""

    Token <- Blanks ( { TildeAt / Special / String / BrokenString / Comment / Etc } )

    Blanks <- \s*
    TildeAt <- '~@'
    Special <- [\[\]{}()'`~^@]
    BrokenString <- '"' ("\\" . / [^"])*
    String <- BrokenString '"'
    Comment <- ';' .*
    Etc <- (!Misc .)+
    Misc <- \s / '[' / ']' / '{' / '}' / '(' / ['] / '"' / '`' / ',' / ';' / ')'

    """


proc peek(reader: Reader): Token =
    reader.tokens[reader.position]


proc next(reader: var Reader): Token =
    result = peek(reader)
    inc reader.position
    reader.eof = reader.position >= reader.tokens.len

proc tokenize*(input: string): seq[Token] =
    result = @[]
    for substr in findAll(input, p):
        result.add(Token(strip(substr)))


proc read_form(reader: var Reader): MalType


proc read_atom(reader: var Reader): MalType =
    var tok = next(reader)
    if tok =~ peg"\d+":
        result = MalType(kind: mttInt, intVal: parseInt(tok))
    elif tok == "nil":
        result = mal_nil
    elif tok == "true":
        result = mal_true
    elif tok == "false":
        result = mal_false
    elif tok[0] == '"':
        if tok.len == 1 or tok[tok.len - 1] != '"':
            result = MalType(kind: mttParseError, errorMessage: "EOF while scanning string.")
        else:
            result = MalType(kind: mttStr, strVal: tok)
    else:
        result = MalType(kind: mttAtom, atomVal: tok)


proc read_list(reader: var Reader): MalType =
    var items : seq[MalType] = @[]
    discard next(reader)  # Skip the '('.
    while true:
        if reader.eof:
            return MalType(kind: mttParseError, errorMessage: "EOF while scanning list.")
        if peek(reader) == ")":
            discard next(reader)  # Skip the ')'.
            break
        items.add(read_form(reader))
    result = MalType(kind: mttList, listVal: items)


proc read_form(reader: var Reader): MalType =
    if reader.eof:
        # Blank or empty input, not really an error.
        return MalType(kind: mttParseError, errorMessage: "")
    case peek(reader)[0]
    of '(':
        result = read_list(reader)
    else:
        result = read_atom(reader)


proc tokens_to_reader(tokens: seq[Token]): Reader =
    var reader: Reader = (
        tokens: tokens,
        position: 0,
        eof: tokens.len == 0
        )
    reader


proc read_str*(str: string): MalType =
    var reader = tokens_to_reader(tokenize(str))
    read_form(reader)
