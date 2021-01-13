

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


%-----------------------------------




read_(Codes, Foo) :-
    phrase(tokens(Ts), Codes),
    phrase(read_form(Foo), Ts).
eval --> !.
print(Foo, Codes) :-
    phrase(pr_str(Foo), Codes).

rep --> read_, eval, print.



%-----------------------------------




:- use_module(library(dcg/basics)).

tokens([T|Ts]) --> token(T), !, tokens(Ts).
tokens([]) --> blanks_or_commas.

token(Tok) -->
    blanks_or_commas,
    ( tildeAt(Tok)
    | special(Tok)
    | string_lit(Tok)
    | comment(Tok)
    | etcs(Tok)
    ).

blanks_or_commas --> (blank | ","), blanks_or_commas.
blanks_or_commas --> [].

tildeAt('~@') --> "~@".

special('[')  --> "[".
special(']')  --> "]".
special('{')  --> "{".
special('}')  --> "}".
special('(')  --> "(".
special(')')  --> ")".
special(single_quote)  --> [39].
special('`')  --> "`".
special('~')  --> "~".
special('^')  --> "^".
special('@')  --> "@".

string_lit("") --> [34], [34].

comment(C) --> ";", rest(C).

rest(X, X, X).

etcs([Ch|Chs]) --> etc(Ch), etcs(Chs).
etcs([Ch]) --> etc(Ch).

etc(Ch) --> [Ch], { \+ fooo(Ch) }.

fooo(Ch) :- code_type(Ch, space).
fooo(Ch) :- special(_, [Ch], []).
fooo(0',).



%-----------------------------------


read_form(Mal) --> read_list(Mal) | read_atom(Mal).

read_list(mal_list(M)) --> ['('], read_list_(M), [')'].

read_list_([M|Ms]) --> read_form(M), read_list_(Ms).
read_list_([]) --> [].

read_atom(int(N))  --> [A], {integer(N, A, [])}, !.
read_atom(atom(A))  --> [[Code|Codes]], {atom_codes(A, [Code|Codes])}.


pr_str(int(I)) --> integer(I).
pr_str(atom(A)) --> {atom_codes(A, Codes)}, Codes.

pr_str(mal_list(ML)) --> "(", pr_s(ML), ")", !.

pr_s([]) --> !.
pr_s([Head]) --> pr_str(Head), !.
pr_s([Head|Tail]) --> pr_str(Head), " ", pr_s(Tail).
