% If-then-else function, where I represents the if clause, 
% T represents the then clause and E represents the else clause.
ite(I,T,_E) :- 
    I, !, T.
ite(_I,_T,E) :- E.

it(I, T) :-
    I, !, T.