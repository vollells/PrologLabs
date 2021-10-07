% not_member(E, L) checks if E is not a member of list L.
not_member(_, []).
not_member(E, [H|T]) :-
        dif(E, H),
        not_member(E, T).

% valid_side(M, C) checks so there aren't too many cannibals C on a side.
valid_side(0, _).
valid_side(M, C) :-
        0 =< M,
        0 =< C,
        C =< M.

% valid_state(State) checks so the state State is valid.
valid_state([ML, CL, MR, CR, _]) :-
        valid_side(ML, CL),
        !,
        valid_side(MR, CR).

% boat(M, C) defines all valid boat combinations.
boat(1, 0).
boat(0, 1).
boat(1, 1).
boat(2, 0).
boat(0, 2).

% pos_state(State, Visited, NextState) produces all posible next valid states.
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

% bf(Current, Goal) is breadth first search, see the book p.185-186.
bf([[[0,0,3,3,right]|Branch]|_Branches], [[0,0,3,3,right]|Branch]).
bf([[Leaf|Branch]|Branches], Goal) :-
        findall(PosState, pos_state(Leaf, [Leaf|Branch], PosState), PosStates),
        expand([Leaf|Branch], PosStates, NewBranches),
        append(Branches, NewBranches, NextBranches),
        bf(NextBranches, Goal).

% expand(Visited, Neighbours, Paths) adds possible paths to Paths.
expand(_, [], []).
expand(X, [Y|Z], [[Y|X]|W]) :-
        expand(X,Z,W).

% df(Start, End, Path) depth first search, see the book p.181-182.
df(X, Y, Path) :-
        df(X, Y, [X], Path).
df(X, X, Visited, Visited).
df(X, Z, Visited, Path) :-
        pos_state(X, [X|Visited], Y),
        df(Y, Z, [Y|Visited], Path).

% print_path(List) prints all list items in List on a new line.
print_path([]).
print_path([H|T]) :-
        write(H),
        write('\n'),
        print_path(T).

% pretty_print_bf() prints the bfs paths pretty.
pretty_print_bf() :-
        bf([[[3,3,0,0,left]]], Path),
        print_path(Path).

% pretty_print_df() prints the dfs paths pretty.
pretty_print_df() :-
        df([3,3,0,0,left], [0,0,3,3,right], Path),
        print_path(Path).
