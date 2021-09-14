% These are facts! Given graph!
edge(a, b).
edge(a, c).
edge(b, c).
edge(c, d).
edge(c, e).
edge(d, f).
edge(d, h).
edge(e, f).
edge(e, g).
edge(f, g).

% Is there a path between node A and B.
path(A, B) :- edge(A, B).
path(A, B) :- edge(C, B), path(A, C).

% Records path between node A and B, if such a path exists.
path(A, B, [A, B]) :- edge(A, B).
path(A, B, [A|As]) :- edge(A, C), path(C, B, As).

/*
  Records the length of a path between node A and B,
  if such a path exists.
*/
npath(A, B, L) :- path(A, B, P), length(P, L).

% For test results look in file "lab1_ex2_res.txt".