% Include necessary files for lab.
:- include('scanner.pl').
:- include('lab2_ex3.pl').

/*
 * run(In, String, Out) first scans String and tokenizes it. The Tokens are then
 * parsed with parse and the parsed tokens are then lastly executed with execute
 * as defined in the Lab-PM.
 */
run(In, String, Out) :-
        scan_swi_prolog(String, Tokens),
        parse(Tokens, AbstStx),
        execute(In, AbstStx, Out).

/*
 * parse(Tokens, AbstStx) parses the Tokens and returns it as an abstract syntax
 * executable by our abstract machine.
 */
parse(Tokens, AbstStx) :-
        pgm(AbstStx, Tokens, []).

% pgm(Cmd) enterprets the command Cmd.
pgm(Cmd) --> cmd(Cmd).
/*
 * pgm(seq(Cmd, Pgm)) is used if we have multiple commands to run and sets them
 * in a recursive seq-structure for the abstract machine.
 */
pgm(seq(Cmd, Pgm)) --> cmd(Cmd), [;], pgm(Pgm).

/*
 * cmd parses the commands while, skip, if and ':=', which is a set.
 * It then recursively breaks checks if there is another command.
 */
cmd(while(Bool, Pgm)) --> [while], bool(Bool), [do], pgm(Pgm), [od].
cmd(skip)--> [skip].
cmd(if(Bool, Pgm1, Pgm2)) -->
        [if], bool(Bool), [then],
        pgm(Pgm1), [else], pgm(Pgm2), [fi].
cmd(set(Var, Exp)) --> [Var], [:=], expr(Exp).

/*
 * bool checks if we have an boolean evaluation.
 */
bool(Exp1<Exp2) --> expr(Exp1), [<], expr(Exp2).
bool(Exp1>Exp2) --> expr(Exp1), [>], expr(Exp2).
bool(Exp1=<Exp2) --> expr(Exp1), [=<], expr(Exp2).
bool(Exp1>=Exp2) --> expr(Exp1), [>=], expr(Exp2).
bool(Exp1==Exp2) --> expr(Exp1), [==], expr(Exp2).

/*
 * expr checks if we need to evaluate an addition operation.
 */
expr(Fact+Exp) --> factor(Fact), [+], expr(Exp).
expr(Fact) --> factor(Fact).

/*
 * factor checks if an multiplication operation need to be evaluated.
 */
factor(Term*Fact) --> term(Term), [*], factor(Fact).
factor(Term) --> term(Term).

/*
 * term checks if the basic element is a variable or constant.
 */
term(id(Id)) --> [id(Id)].
term(num(Num)) --> [num(Num)].
