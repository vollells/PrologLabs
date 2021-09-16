% middle(X, [X]).
% middle(X, [First|Xs]) :-
%         append(Middle, [Last], Xs),
%         middle(X, Middle).


/*
  Order 1 (Above Order):
  We get a single solution for the first query
  while the second query results in infinte solutions with a in the
  middle.

  First Query:
  It checks if the base case is valid (it is not). It then tries the
  next case which removes the first and last element of the list, and
  then it looks for the center of the created list.

  Second Query:
  It checks the base case which is the first valid middle of an list.
  It will then continue adding an element on both sides of the element,
  this will continue forever.
*/

% middle(X, [First|Xs]) :-
%         append(Middle, [Last], Xs),
%         middle(X, Middle).
% middle(X, [X]).

/*
  Order 2 (Above Order):
  The first query is still finite while the second query loses
  the first basecase result of a list with a single element [a].

  First Query:
  It works similarly as the first query in the above order but the base
  case is checked last instead of first.

  Second Query:
  It gets stuck in the infinite recursive case possibilities before
  checking the base case. It results in a lose of the base case [a] as a
  solution.
*/

% middle(X, [First|Xs]) :-
%         middle(X, Middle),
%         append(Middle, [Last], Xs).
% middle(X, [X]).

/*
  Order 3 (Above Order):
  First query exceeds the stack limit, which results in a crash. (N/A finite)
  Second query also exceeds the stack limit. (N/A finite)

  First Query:
  It removes the first element and tries to find the middle of the new
  list, which is now skewed. This results in a infinite loop which
  exceeds the stack limit and never terminates.

  Second Query:
  It continues to add "a" onto the front of list. This would result in
  a infinite list that ends with "a", but since it is infinite it
  exceeds the stack limit.
*/

% middle(X, [X]).
% middle(X, [First|Xs]) :-
%         middle(X, Middle),
%         append(Middle, [Last], Xs).

/*
  Order 4 (Above Order):
  First query a solution but tries to continue the search which
  leads to the same infinite case as the order above.
  Second query gives the same infinite response as the first order
  response.

  First Query:
  It ignores the base case, then it continues to the recursive case.
  There is removes the first element and then unifies the variable X
  and Middle. Append then removes the last element which results in
  Middle and therefore X to be unified with b.

  Second Query:
  It starts by getting the base case solution which is [a].
  It then continues to the recursive case where it adds a temporary
  variable to the start of the list and recursively calls middle with "a"
  which it is. append then adds a temporary variable to the end of the
  list.
*/


% SLD 1:
% Query: middle(X, [a,b,c]).
% middle(X, [X]).
% middle(X, [First|Xs]) :-
%         append(Middle, [Last], Xs),
%         middle(X, Middle).

/*
          middle(X0, [a,b,c]).
                   |
                  (1) - X/X0, First/a, Xs/[b,c] "Enters second Clause"
                   |
     append(Middle, [Last], [b,c]),
              middle(X0, [b]).
                   |
                  (2) - X/X0, X/b "Enters first Clause"
                   |
               middle(X0, [b]).
             /                 \
          true                 (3) - X/X0, First/b, Xs/[] "Enters second Clause"
                                \
                     append(Middle, [Last], []),
                           middle(X0, []).
                                 |
                                (4) - X/X0, X/ "Enters first Clause"
                                 |
                           middle(X0, []).
                                 |
                               false
*/

% SLD 2:
% Query: middle(a, X).
middle(X, [First|Xs]) :-
        append(Middle, [Last], Xs),
        middle(X, Middle).
middle(X, [X]).

/*
                       -------------- middle(a, X0). ----------- (7) ...
                      |                     |
                     (1)                   (6)
                      |                    ...
         append(Middle, [Last], Xs0),
        /                          \
      (2)                         (3)
       |                           |
   middle(a, [])               middle(a, X1).
       |                      /              \
     false                  (4)              (5)
                             |                |
              append(Middle, [Last], [])  middle(a, [X1])
                             |                |
                           false             true


 (1) - X/a, X0/[First0|Xs0] "Enters first Clause"
 (2) - Middle/[]
 (3) - Middle/X1
 (4) - X/a, X1/[First1|Xs1] "Enters first Clause"
 (5) - X/a, X/X1 "Enters second Clause"
 (6) - Another branch like the one after (1), the only difference being
       another temp variable is added before and after [a]
 (7) - More branches with more temp variables
*/

% If you ask for more than one answer you will pass into another one of
% the main branches, i.e. (1),(6),(7)......