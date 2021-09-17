% Lol vim sucks
id(I).
num(N) :- number(N).

execute(BE, skip, BE).
execute(BE, seq(C1, C2), BEO) :- execute(BE, C1, Res1), execute(Res1, C2, BEO).

execute(BE, while(B, C), BEO) :-
        boolean_exp(BE, B, TV),
        TV=tt,
        execute(BE, C, BEO).

execute(BE, while(B, _), BE) :- boolean_exp(BE, B, TV), TV=ff.

execute(BE, if(B, C1, _), BEO) :-
        boolean_exp(BE, B, TV),
        TV=tt,
        execute(BE, C1, BEO).

execute(BE, if(B, _, C2), BEO) :-
        boolean_exp(BE, B, TV),
        TV=ff,
        execute(BE, C2, BEO).

execute(BE, set(id(I), E), BEO) :-
        member([I,_], BE),
        arithmetic_exp(BE, E, N),
        replace(BE, I, N, BEO).
execute(BE, set(id(I), E), BEO) :-
        arithmetic_exp(BE, E, N),
        append(BE, [[I,N]], BEO).

% Less than
boolean_exp(BE, E1 < E2, TV) :-
        arithmetic_exp(BE, E1, E1V),
        arithmetic_exp(BE, E2, E2V),
        E1V < E2V,
        TV is tt.
boolean_exp(BE, E1 < E2, TV) :-
        arithmetic_exp(BE, E1, E1V),
        arithmetic_exp(BE, E2, E2V),
        E1V >= E2V,
        TV is ff.

% Greater than
boolean_exp(BE, E1 > E2, TV) :-
        arithmetic_exp(BE, E1, E1V),
        arithmetic_exp(BE, E2, E2V),
        E1V > E2V,
        TV is tt.
boolean_exp(BE, E1 > E2, TV) :-
        arithmetic_exp(BE, E1, E1V),
        arithmetic_exp(BE, E2, E2V),
        E1V =< E2V,
        TV is ff.

% Less than or equal
boolean_exp(BE, E1 =< E2, TV) :-
        arithmetic_exp(BE, E1, E1V),
        arithmetic_exp(BE, E2, E2V),
        E1V =< E2V,
        TV is tt.
boolean_exp(BE, E1 =< E2, TV) :-
        arithmetic_exp(BE, E1, E1V),
        arithmetic_exp(BE, E2, E2V),
        E1V > E2V,
        TV is ff.

% Greater than or equal
boolean_exp(BE, E1 >= E2, TV) :-
        arithmetic_exp(BE, E1, E1V),
        arithmetic_exp(BE, E2, E2V),
        E1V >= E2V,
        TV is tt.
boolean_exp(BE, E1 >= E2, TV) :-
        arithmetic_exp(BE, E1, E1V),
        arithmetic_exp(BE, E2, E2V),
        E1V < E2V,
        TV is ff.

% Equal
boolean_exp(BE, E1 == E2, TV) :-
        arithmetic_exp(BE, E1, E1V),
        arithmetic_exp(BE, E2, E2V),
        E1V == E2V,
        TV is tt.
boolean_exp(BE, E1 == E2, TV) :-
        arithmetic_exp(BE, E1, E1V),
        arithmetic_exp(BE, E2, E2V),
        E1V \== E2V,
        TV is ff.


arithmetic_exp(BE, id(I), FV) :- member([I, FV], BE).
arithmetic_exp(_BE, num(N), N) :- num(N).
arithmetic_exp(BE, E1+E2, FV) :-
        arithmetic_exp(BE, E1, E1V),
        arithmetic_exp(BE, E2, E2V),
        FV is E1V + E2V.
arithmetic_exp(BE, E1-E2, FV) :-
        arithmetic_exp(BE, E1, E1V),
        arithmetic_exp(BE, E2, E2V),
        FV is E1V - E2V.
arithmetic_exp(BE, E1*E2, FV) :-
        arithmetic_exp(BE, E1, E1V),
        arithmetic_exp(BE, E2, E2V),
        FV is E1V * E2V.
arithmetic_exp(BE, E1/E2, FV) :-
        arithmetic_exp(BE, E1, E1V),
        arithmetic_exp(BE, E2, E2V),
        FV is E1V / E2V.


replace([[H1,H2]|BEs], ID, Val, [[H1|H2]|Tmp]) :- replace(BEs, ID, Val, Tmp).
replace([[ID,_H2]|BEs], ID, Val, [[ID|Val]|BEs]).


