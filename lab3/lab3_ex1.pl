% Definite Clause Grammars
:- include('scanner.pl').
:- include('lab2_ex3.pl').

run(In, String, Out) :-
        scan_swi_prolog(String, Tokens),
        write(Tokens),
        parse(Tokens, AbstStx),
        write(AbstStx),
        execute(In, AbstStx, Out).

parse(Tokens, AbstStx) :-
        pgm(AbstStx, Tokens, []).

pgm(Cmd) --> cmd(Cmd).
pgm(seq(Cmd, Pgm)) --> cmd(Cmd), [;], pgm(Pgm).

cmd(while(Bool, Pgm)) --> [while], bool(Bool), [do], pgm(Pgm), [od].
cmd(skip)--> [skip].
cmd(if(Bool, Pgm1, Pgm2)) -->
        [if], bool(Bool), [then],
        pgm(Pgm1), [else], pgm(Pgm2), [fi].
cmd(set(Var, Exp)) --> [Var], [:=], expr(Exp).

bool(Exp1<Exp2) --> expr(Exp1), [<], expr(Exp2).
bool(Exp1>Exp2) --> expr(Exp1), [>], expr(Exp2).
bool(Exp1=<Exp2) --> expr(Exp1), [=<], expr(Exp2).
bool(Exp1>=Exp2) --> expr(Exp1), [>=], expr(Exp2).
bool(Exp1==Exp2) --> expr(Exp1), [==], expr(Exp2).

expr(Fact+Exp) --> factor(Fact), [+], expr(Exp).
expr(Fact) --> factor(Fact).

factor(Term*Fact) --> term(Term), [*], factor(Fact).
factor(Term) --> term(Term).

term(id(Id)) --> [id(Id)].
term(num(Num)) --> [num(Num)].


