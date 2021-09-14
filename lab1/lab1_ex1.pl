% This is facts.
beautiful(ulrika).
beautiful(nisse).
beautiful(peter).
rich(nisse).
rich(anne).
woman(ulrika).
woman(anne).
man(nisse).
man(peter).
man(bosse).
strong(anne).
strong(peter).
strong(bosse).
kind(bosse).

% X likes Y
% All men likes beautiful women.
likes(X,Y) :-
        man(X),
        woman(Y),
        beautiful(Y).
% Nisse likes all women who likes Nisse.
likes(nisse, Y) :- woman(Y), likes(Y, nisse).
% Peter likes everyone who is kind.
likes(peter, Y) :- kind(Y).
% Ulrika likes men who like her and are:
% rich and kind.
likes(ulrika, Y) :- man(Y), rich(Y), kind(Y), likes(Y, ulrika).
% strong and beautiful.
likes(ulrika, Y) :- man(Y), strong(Y), beautiful(Y), likes(Y, ulrika).

% Rich people are happy
happy(X) :- rich(X).
% All men who like a woman who likes him are happy.
happy(X) :- man(X), woman(Y), likes(X,Y), likes(Y,X).
% All women who like a man who likes her are happy.
happy(X) :- woman(X), man(Y), likes(X,Y), likes(Y,X).

/*
  The answers to the quetions given in the lab PM is in the res file
  "lab1_ex1_res.txt".

  The order of the clauses was determined by starting with the facts and then
  implementing rules. We also clustered all the facts and rules which were
  regarding the same property.

  The premise order start with single fact limitations and then any relational
  limitations.
*/