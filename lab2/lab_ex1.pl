% issorted: Checks if list is sorted!
issorted([_H]).
issorted([H1|[H2|T]]) :- H1 =< H2, issorted([H2|T]).

% findsmallest: Finds/verifies the smallest element of an list.
findsmallest([H], M) :- M = H.
findsmallest([H1|[H2|T]], M) :- H1 =< H2, findsmallest([H1|T], M).
findsmallest([H1|[H2|T]], M) :- H2 < H1, findsmallest([H2|T], M).

% reel: Removes an element from an list, which it then outputs.
reel([], _, []).
reel([X], X, []).
reel([X|Xs], E, Ys) :- dif(X, E), reel(Xs, E, Ys1), append([X], Ys1, Ys).
reel([E|Xs], E, Ys) :- append([], Xs, Ys).

% ssort: Selection Sort according to lab pm.
ssort([], []).
ssort(L, [L1|LS]) :- findsmallest(L, L1), reel(L, L1, R), ssort(R, LS).

% less: This divides a list according to if the elements are smaller or
% larger to a selected pivot element.
less([], _, [], []).
less([X|Xs], L, Gs, [X|Ss]) :- X<L, less(Xs, L, Gs, Ss).
less([X|Xs], L, [X|Gs], Ss) :- X>=L, less(Xs, L, Gs, Ss).

% qsort: Quicksort according to lab pm.
qsort([], []).
qsort([X], [X]).
qsort([L|Ls], Ns) :-
        less(Ls, L, Gs, Ss),
        qsort(Ss, SSs),
        qsort(Gs, SGs),
        append(SSs, [L|SGs], Ns).

