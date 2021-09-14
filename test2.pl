is_number(0).
is_number(1).
is_number(2).

binary_tree(void).
binary_tree(tree(N, T1, T2)) :-
        binary_tree(T1),
        binary_tree(T2),
        is_number(N).

search(Number, tree(Number, _T1, _T2)).
search(Number, tree(_N, T1, _T2)) :- search(Number, T1).
search(Number, tree(_N, _T1, T2)) :- search(Number, T2).

longer([_|_], []).
longer([_X|Xs], [_Y|Ys]) :- longer(Xs, Ys).

evenlength([]).
evenlength([_X, _Y| Xs]) :- evenlength(Xs).

last([X], X).
last([_Y|Xs], X) :- last(Xs, X).
nger(Xs, Ys).

evenlength([]).
evenlength([_X, _Y| Xs]) :- evenlength(Xs).

last([X], X).
last([_Y|Xs], X) :- last(Xs, X).

reverse([], []).
reverse([X, Xs], Ys) :- reverse(Xs, Y1s), append(Y1s, [X], Ys).

nonmember0(_, []).
nonmember0(X, [Y,Ys]) :-
        dif(X,Y),
        nonmember0(X,Ys).

uniquify([], []).
uniquify([X|Xs], [X|Ys]) :-
    nonmember0(X, Xs),
    uniquify(Xs, Ys).
uniquify([X|Xs], Ys) :-
    member(X, Xs),
    uniquify(Xs, Ys).