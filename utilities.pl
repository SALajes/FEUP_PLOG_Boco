%If-then-else predicate, where I represents the if clause, 
%T represents the then clause and E represents the else clause
ite(I,T,_E) :- 
    I, !, T.
ite(_I,_T,E) :- E.

%If-then predicate, where I represents the if clause and
%T represents the then clause
it(I, T) :-
    I, !, T.
