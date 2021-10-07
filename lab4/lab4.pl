boat()

pos_state([ML, CL, MR, CR, left], Visited, NextState) :-
        boat(MTrans, CTrans),
        MLNext is ML - MTrans,
        CLNext is CL - CTrans,
        MRNext is MR + MTrans,
        CRNext is CR + CTrans,
        NextState = [MLNext, CLNext, MRNext, CRNext, right],
        valid_state(NextState),
        not_member(NextState, Visited).

pos_state([ML, CL, MR, CR, right], Visited, NextState) :-
        boat(MTrans, CTrans),
        MLNext is ML + MTrans,
        CLNext is CL + CTrans,
        MRNext is MR - MTrans,
        CRNext is CR - CTrans,
        NextState = [MLNext, CLNext, MRNext, CRNext, left],
        valid_state(NextState),
        not_member(NextState, Visited).


bf([[[0,0,3,3,right]|Branch]|_Branches ],  [[0,0,3,3,right]|Branch]).
bf([[Leaf |Branch] | Branches ], Goal) :-
        findall(PosState, pos_state(Leaf, [Leaf|Banch], PosState), PosStates),
        expand([Leaf |Branch], PosStates, NewBranches),
        append(Branches, NewBranches, NextBranches),
        bf(NextBranches ,Goal).

expand(X, [], []).
expand(X, [Y|Z], [[Y|X]|W]) :-
        expand(X,Z,W).