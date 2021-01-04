import pegs

var lines = @[
    "tuesday",
    "  )",
    "gggg",
    "[",
    "  ~@",
    "  \"hey \\\"there\"",
    "  ;heyeyrerer  "]


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


echo "-------------------------"

for line in lines:
    echo ">", line
    if line =~ p:
        echo matches[0]
    else:
        echo ":("
