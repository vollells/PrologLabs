true_formula(true).

true_formula(and(X, Y)) :- true_formula(X), true_formula(Y).
true_formula(or(X, Y)) :- true_formula(X), formula(Y).
true_formula(or(X, Y)) :- formula(X), true_formula(Y).
true_formula(not(X)) :- false_formula(X).

false_formula(false).
false_formula(and(X, Y)) :- false_formula(X), formula(Y).
false_formula(and(X, Y)) :- formula(X), false_formula(Y).
false_formula(or(X, Y)) :- false_formula(X), false_formula(Y).
false_formula(not(X)) :- true_formula(X).

formula(X) :- false_formula(X).
formula(X) :- true_formula(X).

q(a).
q(X) --> \+p(X).
p(Y) --> q(s(Y)).
