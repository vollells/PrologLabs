% Constraint Logic Programming Lab 5.1
:- use_module(clpfd).

container(a, 2, 2).
container(b, 4, 1).
container(c, 2, 2).
container(d, 1, 1).

% container(aa, 2, 2). container(ab, 3, 2).
% container(ac, 5, 5). container(ba, 6, 2).
% container(bb, 1, 2). container(bc, 3, 3).
% container(ca, 3, 2). container(cb, 5, 2).
% container(cc, 2, 3).

on(a,d).
on(b,c).
on(c,d).

% on(aa, ba). on(ab, ba). on(ab, bb). on(ac, ba).
% on(ac, bb). on(ac, bc). on(ba, ca). on(ba, cb).
% on(bb, cb). on(bc, cb). on(bc, cc).

/*
 * max_time(Cs, D) take in a list of containers Cs and returns the
 * longest duration D.
 */
max_time([[_I, _W, D]], D).
max_time([[_I, _W, D]|Tail], TimeNew) :-
        TimeNew #= D + Time,
        max_time(Tail, Time).

/*
 * constraints(I1, I2, S1, S2, E1, E2) applies the relevant constraints
 * depending on if a container is on / not on another container.
 */
constraints(I1, I2, _S1, S2, E1, _E2) :-
        on(I1, I2),
        S2 #>= E1.
constraints(I1, I2, S1, _S2, _E1, E2) :-
        on(I2, I1),
        S1 #>= E2.
constraints(I1, I2, _S1, _S2, _E1, _E2) :-
        \+(on(I1, I2)),
        \+(on(I2, I1)).

/*
 * constrain_loop1(Cs, Ss, Es) is the inner loop which matches containers
 * against each other. Applying relevant constraints.
 */
constrain_loop1([_], [_], [_]).
constrain_loop1([[I, W, D],[I2, _W2, _D2]|Cs], [S,S2|Ss], [E,E2|Es]) :-
        constraints(I, I2, S, S2, E, E2),
        constrain_loop1([[I, W, D]|Cs], [S|Ss], [E|Es]).

/*
 * constrain_loop2(Cs, Ss, Es) is the outer loop which matches containers
 * against each other.
 */
constrain_loop2([_], [_], [_]).
constrain_loop2([[I, W, D],[I2, W2, D2]|Cs], [S,S2|Ss], [E,E2|Es]) :-
        constrain_loop1([[I, W, D],[I2, W2, D2]|Cs], [S,S2|Ss], [E,E2|Es]),
        constrain_loop2([[I2, W2, D2]|Cs], [S2|Ss], [E2|Es]).

/*
 * generate_task(Cs, Ss, Es, Tasks) Takes in the containers Cs, Start
 * Times Ss, and End Times Es and outputs the generated tasks in the
 * list Tasks.
 */
generate_tasks(_, _, [], []).
generate_tasks([[I, W, D]|Cs], [S|Ss], [E|Es], [T|Tasks]) :-
        T = task(S, D, E, W, I),
        generate_tasks(Cs, Ss, Es, Tasks).

% find_largest(Es, L) finds the largest End Time L in the End Time list Es.
find_largest([], _).
find_largest([E|Es], L) :-
        L #>= E,
        find_largest(Es, L).

/*
 * schedule(Workers, EndTime, Cost) Is the main program which finds all
 * containers, limits list sizes, applies all the constraints, and
 * generates the tasks based on the result. Then it finds and summarizes
 * the results.
 */
schedule(Workers, EndTime, Cost) :-
        findall([Id, Workers, Duration],
                container(Id, Workers, Duration),
                Containers),

        length(Containers, L),
        length(Ss, L),
        length(Es, L),

        max_time(Containers, MaxT),
        Ss ins 0..MaxT,
        Es ins 0..MaxT,
        EndTime in 1..MaxT,

        find_largest(Es, EndTime),
        Workers in 1..100,

        constrain_loop2(Containers, Ss, Es),
        generate_tasks(Containers, Ss, Es, Tasks),

        cumulative(Tasks, [limit(Workers)]),
        Cost #= Workers*EndTime,
        labeling([min(Cost)], [Cost, EndTime|Ss]).
