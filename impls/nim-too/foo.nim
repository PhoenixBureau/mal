import pegs, strutils

var lines = @[
    "tuesday",
    "  )",
    "gggg",
    "[",
    "  ~@",
    "  \"hey \\\"there\"",
    ",",
    "  ;heyeyrerer  ",
    ]


var p = peg"""

    Token <- Blanks ( { TildeAt / Special / String / Comment / Etc } )

    Blanks <- \s*
    TildeAt <- '~@'
    Special <- [\[\]{}()'`~^@]
    String <- "\"" ("\\" . / [^"])* "\""
    Comment <- ';' .*
    Etc <- (!Misc .)+
    Misc <- \s / '[' / ']' / '{' / '}' / '(' / ['] / '"' / '`' / ',' / ';' / ')'

    """


echo "-------------------------"

# for line in lines:
#     echo ">", line
#     if line =~ p:
#         echo matches[0]
#     else:
#         echo ":("


for substr in findAll(join(lines, " "), p):
#     echo substr
# for substr in findAll("   ,   ", p):
    echo substr
