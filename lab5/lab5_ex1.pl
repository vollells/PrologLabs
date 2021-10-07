% comment hello.
:- use_module(library(clpfd)).

container(a, 2, 2).
container(b, 4, 1).
container(c, 2, 2).
container(d, 1, 1).

on(a,d).
on(b,c).
on(c,d).

max_time([[_I, _W, D]], D).
max_time([[_I, _W, D]|Tail], TimeNew) :-
        TimeNew #= D + Time,
        max_time(Tail, Time).


constrain([[_I, _W, D]|Cs], [S|Ss], [E|Es]) :-
        % MAGIC WITH MAGIT

schedule(Workers, EndTime, Cost) :-

        findall([Id, Workers, Duration],
                container(Id, Workers, Duration),
                Containers),

        length(Containers, L),
        length(Ss, L),
        length(Es, L),

        max_time(Containers, MaxT),
        domain(Ss, 0, MaxT),
        domain(Es, 0, MaxT),

        cumulative(Tasks, [limit(Workers)]),
        Cost #= Workers*EndTime,
        labeling([minimize(Cost)], [Cost|StartTimes]).
