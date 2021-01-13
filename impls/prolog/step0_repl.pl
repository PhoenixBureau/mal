
:- initialization(loop).

loop :-
    prompt(Line),
    loop(Line, [], _Out).

loop(end_of_file ,  S,   S) :- !.
loop( Line, In, Out) :-
  do_line(Line, In, S),
  prompt(NextLine), !,
  loop(NextLine, S, Out).

do_line(Line, _, _) :-
    rep(Line, Output),
    outy(Output).

prompt(Codes) :-
    write('user> '),
    read_line_to_codes(user_input, Codes).

outy(C) :-
    string_codes(S, C),
    writeln(S).






read_ --> !.
eval --> !.
print --> !.

rep --> read_, eval, print.