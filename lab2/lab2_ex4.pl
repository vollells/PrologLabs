/*
  union(X, Y, R) X and Y are sets and R is the resulting union of
  Y and X.
*/

union([],[],[]).
union([X|Xs],[],[X|Rs]) :- union(Xs, [], Rs).
union([],[Y|Ys],[Y|Rs]) :- union([], Ys, Rs).
union([X|Xs],[Y|Ys],[X|Rs]) :-
        X == Y,
        union(Xs, Ys, Rs).
union([X|Xs],[Y|Ys],[X|Rs]) :-
        X @< Y,
        union(Xs, [Y|Ys], Rs).
union([X|Xs],[Y|Ys],[Y|Rs]) :-
        X @> Y,
        union([X|Xs], Ys, Rs).

/*
  intersection(X, Y, R) X and Y are sets and R is the resulting intersection
  of Y and X.
*/
intersection([],[],[]).
intersection([_X|Xs],[], Rs) :- intersection(Xs, [], Rs).
intersection([],[_Y|Ys], Rs) :- intersection([], Ys, Rs).
intersection([X|Xs],[Y|Ys],[X|Rs]) :-
        X == Y,
        intersection(Xs, Ys, Rs).
intersection([X|Xs],[Y|Ys], Rs) :-
        X @< Y,
        intersection(Xs, [Y|Ys], Rs).
intersection([X|Xs],[Y|Ys], Rs) :-
        X @> Y,
        intersection([X|Xs], Ys, Rs).


% subset(Xs, Ys) Xs and Ys checks is Xs is a subset of Ys.
subset([], []).
subset([H|Xs], [H|Ys]) :- subset(Xs, Ys).
subset([_|Xs], Ys) :- subset(Xs, Ys).

% powerset(X, R) X are a set and R is resulting powerset of X.
powerset(S, R) :-
        findall(X, subset(S, X), R).
