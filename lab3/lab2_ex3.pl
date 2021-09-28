% id(_I), _I is an id.
% num(N), N is a number.
id(_I).
num(N) :- number(N).

/*
 * execute(BE, C, BEO).
 * executes command C and puts resulting binding enviroment BEO.
 */
% skip does nothing.
execute(BE, skip, BE).

% seq(C1, C2) first executes C1 then C2.
execute(BE, seq(C1, C2), BEO) :- execute(BE, C1, Res1), execute(Res1, C2, BEO).

% while(B, C) executes C while B is true (1).
execute(BE, while(B, C), BEO) :-
        boolean_exp(BE, B, TV),
        TV=1,
        execute(BE, C, Temp),
        execute(Temp, while(B, C), BEO).
execute(BE, while(B, _), BE) :- boolean_exp(BE, B, TV), TV=0.

% if(B, C1, C2) executes C1 if B is true (1) or C2 if B is false (0).
execute(BE, if(B, C1, _), BEO) :-
        boolean_exp(BE, B, TV),
        TV=1,
        execute(BE, C1, BEO).
execute(BE, if(B, _, C2), BEO) :-
        boolean_exp(BE, B, TV),
        TV=0,
        execute(BE, C2, BEO).

% set(I, E) sets the id I as expression E.
execute(BE, set(id(I), E), BEO) :-
        member([I,_], BE),
        arithmetic_exp(BE, E, N),
        replace(BE, id(I), num(N), BEO).
execute(BE, set(id(I), E), BEO) :-
        \+ member([I,_], BE),
        arithmetic_exp(BE, E, N),
        append(BE, [[I,N]], BEO).

/*
 * boolean_exp(BE, B, TV).
 * determines the truthvalue TV based on whether the boolean expression B holds
 * true (1) or false (0).
 */
% expression E1 less than expression E2.
boolean_exp(BE, E1 < E2, TV) :-
        arithmetic_exp(BE, E1, E1V),
        arithmetic_exp(BE, E2, E2V),
        E1V < E2V,
        TV is 1.
boolean_exp(BE, E1 < E2, TV) :-
        arithmetic_exp(BE, E1, E1V),
        arithmetic_exp(BE, E2, E2V),
        E1V >= E2V,
        TV is 0.

% expression E1 greater than expression E2.
boolean_exp(BE, E1 > E2, TV) :-
        arithmetic_exp(BE, E1, E1V),
        arithmetic_exp(BE, E2, E2V),
        E1V > E2V,
        TV is 1.
boolean_exp(BE, E1 > E2, TV) :-
        arithmetic_exp(BE, E1, E1V),
        arithmetic_exp(BE, E2, E2V),
        E1V =< E2V,
        TV is 0.

% expression E1 less than or equal to expression E2.
boolean_exp(BE, E1 =< E2, TV) :-
        arithmetic_exp(BE, E1, E1V),
        arithmetic_exp(BE, E2, E2V),
        E1V =< E2V,
        TV is 1.
boolean_exp(BE, E1 =< E2, TV) :-
        arithmetic_exp(BE, E1, E1V),
        arithmetic_exp(BE, E2, E2V),
        E1V > E2V,
        TV is 0.

% expression E1 greater than or equal to expression E2.
boolean_exp(BE, E1 >= E2, TV) :-
        arithmetic_exp(BE, E1, E1V),
        arithmetic_exp(BE, E2, E2V),
        E1V >= E2V,
        TV is 1.
boolean_exp(BE, E1 >= E2, TV) :-
        arithmetic_exp(BE, E1, E1V),
        arithmetic_exp(BE, E2, E2V),
        E1V < E2V,
        TV is 0.

% expression E1 equal to expression E2.
boolean_exp(BE, E1 == E2, TV) :-
        arithmetic_exp(BE, E1, E1V),
        arithmetic_exp(BE, E2, E2V),
        E1V == E2V,
        TV is 1.
boolean_exp(BE, E1 == E2, TV) :-
        arithmetic_exp(BE, E1, E1V),
        arithmetic_exp(BE, E2, E2V),
        E1V \== E2V,
        TV is 0.


/*
 * arithmetic_exp(BE, E, FV).
 * arithmetic_exp determines the final value FV of expression E based on the
 * binding enviroment BE.
 */
% num(N) determines if N is a number.
arithmetic_exp(_BE, num(N), N) :- num(N).

% id(I) determines if I is an existing id. It sets the final value FV as the
% corresponding id value in the binding enviroment.
arithmetic_exp(BE, id(I), FV) :- member([I, FV], BE).

% preformes addition on expression E1 and expression E2.
arithmetic_exp(BE, E1+E2, FV) :-
        arithmetic_exp(BE, E1, E1V),
        arithmetic_exp(BE, E2, E2V),
        FV is E1V + E2V.

% preformes subtraction on expression E1 and expression E2.
arithmetic_exp(BE, E1-E2, FV) :-
        arithmetic_exp(BE, E1, E1V),
        arithmetic_exp(BE, E2, E2V),
        FV is E1V - E2V.

% preformes multiplication on expression E1 and expression E2.
arithmetic_exp(BE, E1*E2, FV) :-
        arithmetic_exp(BE, E1, E1V),
        arithmetic_exp(BE, E2, E2V),
        FV is E1V * E2V.

% preformes division on expression E1 and expression E2.
arithmetic_exp(BE, E1/E2, FV) :-
        arithmetic_exp(BE, E1, E1V),
        arithmetic_exp(BE, E2, E2V),
        FV is E1V / E2V.


/*
 * replace(BE, ID, Val, BEO).
 * replace replaces the value of the id ID in the binding enviroment BE with
 * the value Val and returns it in BEO.
 */
replace([[ID, _H2]|BEs], id(ID), num(Val), [[ID, Val]|BEs]).
replace([[H1, H2]|BEs], id(ID), num(Val), [[H1, H2]|Tmp]) :- replace(BEs, id(ID), num(Val), Tmp).
