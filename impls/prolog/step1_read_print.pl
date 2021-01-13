:- use_module(library(dcg/basics)).

% :- initialization(loop).

% swipl --quiet -t loop step1_read_print.pl 

/*

We're going to want to carry along a state of some sort between
iterations of the main loop.  For now it's unused.

*/

loop :-
    prompt(Line),            % Get the first line of user input,
    loop(Line, [], _Out).    % and drop intot the main loop with
                             % an empty list as initial state.

loop(end_of_file, State, State) :- !.
loop(Line, In, Out) :-
  do_line(Line, In, State),
  prompt(NextLine),
  loop(NextLine, State, Out).

do_line(Line, _, _) :-
    rep(Line, Output),
    write_codes(Output).

prompt(Codes) :-
    write('user> '),
    read_line_to_codes(user_input, Codes),
    !.

write_codes(C) :-
    % TODO Look for this in the std libs, etc.
    string_codes(S, C),
    writeln(S).


%------------------------
/* READ EVAL PRINT REP */


read_(Codes, AST) :-
    tokenize(Codes, Tokens),
    read_form(Tokens, AST).

eval --> !.

print(AST, Codes) :-
    % writeln(AST),  % debugging.
    phrase(pr_str(AST), Codes).

rep --> read_, eval, print.



%-----------------------------------
/* Tokenise it, don't critize it. */

tokenize(Codes, Tokens) :- phrase(tokens(Tokens), Codes), !.
tokenize(_, fail) :- writeln("EOF scanning input for tokens.").

% Greedy up tokens ignoring blanks and commas.
tokens([T|Ts]) --> token(T), !, tokens(Ts).

% Handle trailing blanks.
tokens([]) --> blanks_or_commas.

token(Tok) -->
    blanks_or_commas,
    ( tildeAt(Tok)
    | special(Tok)
    | [34], !, string_lit(Tok)
    | comment(Tok)
    | etcs(Tok)
    ).

% (blank//0 is from dcg/basics lib.)
blanks_or_commas --> (blank | ","), blanks_or_commas.
blanks_or_commas --> [].

% (Most of these can be their own AST as Prolog atoms.)

tildeAt('~@') --> "~@".

special('[') --> "[".
special(']') --> "]".
special('{') --> "{".
special('}') --> "}".
special('(') --> "(".
special(')') --> ")".
special(single_quote) --> [39].  % How /do/ you quote ' in Prolog anyhow?
special('`') --> "`".
special('~') --> "~".
special('^') --> "^".
special('@') --> "@".

string_lit([34|S]) --> strchrs(S, [34]), [34].

strchrs([92, 92|Tail], Tail0) --> [92, 92], !, strchrs(Tail, Tail0).
strchrs([92, 34|Tail], Tail0) --> [92, 34], !, strchrs(Tail, Tail0).

strchrs([Ch|Tail], Tail0) --> [Ch], {schr(Ch)}, strchrs(Tail, Tail0).

strchrs(Tail, Tail) --> [].

schr(Ch) :- nonvar(Ch), Ch \= 34, Ch \= 92.

comment(comment(C)) --> ";", rest(C).

rest(X, X, X).  % DCG to grab the rest of the list/line.

% Match one-or-more (not zero-or-more because that would match the end of
% the list/line infinitely many times leading to a non-halting program)
% characters that are of the etc//1 set.
etcs([Ch|Chs]) --> etc(Ch), etcs(Chs).
etcs([Ch]) --> etc(Ch).

% etc//1 defines the set of chars that are NOT in netc//1.
etc(Ch) --> [Ch], { nonvar(Ch), \+ netc(Ch) }.

% netc//1 are spaces, commas, and the above special chars.
netc(Ch) :- code_type(Ch, space).
netc(Ch) :- special(_, [Ch], []).
netc(0',).

% Reusing special//1 as special/3 is a neat trick.  The same code is a
% parser and a database of the grammar.  Yay Prolog!


%-----------------------------------


read_form(fail, fail) :- !.  % Pass through tokenizer failures.
read_form(Tokens, AST) :- phrase(read_form(AST), Tokens), !.
read_form(_, fail) :- writeln("EOF parsing tokens to AST.").

read_form(Mal) --> read_list(Mal) | read_atom(Mal).

read_list(mal_list(M)) --> ['('], read_list_(M), [')'].

read_list_([M|Ms]) --> read_form(M), read_list_(Ms).
read_list_([]) --> [].

read_atom(int(N))  --> [Codes],
    { integer(N, Codes, []) }, !.

read_atom(atom(Atom))  --> [[C|Cs]],
    { atom_codes(Atom, [C|Cs]) }.


pr_str(fail) --> [].
pr_str(int(I)) --> integer(I).
pr_str(atom(A)) --> {atom_codes(A, Codes)}, Codes.
pr_str(comment(C)) --> comment(comment(C)).
pr_str(mal_list(ML)) --> "(", pr_s(ML), ")", !.

pr_s([]) --> [].
pr_s([Head]) --> pr_str(Head), [].
pr_s([Head|[X|Xs]]) --> pr_str(Head), " ", pr_s([X|Xs]).
