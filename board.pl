:- use_module(library(lists)).
% Checks if a number is even
even(X) :-
    0 is X mod 2.

% Checks if a number is odd
odd(X) :-
    1 is X mod 2.

% Prints the last '|' character of each line 
printVertLine(_, 0) :-
    write('|'),
    nl.

% Prints the first row of the board (which is always the same)
printVertLine(Row, _Col) :-
    Row == 10,
    write('|   |               |                   |'),
    nl.


% Prints the last row of the board (which is always the same)
printVertLine(Row, _Col) :-
    Row == 1,
    write('|               |                   |   |'),
    nl.

% Prints a row of the board made of '|' and '\' characters.
printVertLine(Row, Col) :-
    Col\=1,
    Col\=10,
    Row\=1,
    Row\=10,
    even(Row),
    odd(Col),
    write('| \\ '),
    Col2 is Col-1,
    printVertLine(Row, Col2).

% Prints a row of the board made of '|' and '/' characters.
printVertLine(Row, Col) :-
    Col\=1,
    Col\=10,
    Row\=1,
    Row\=10,
    odd(Row),
    even(Col),
    write('| / '),
    Col2 is Col-1,
    printVertLine(Row, Col2).

% Prints a row of the board made of '|' characters.
printVertLine(Row, Col) :-
    write('|   '),
    Col2 is Col-1,
    printVertLine(Row, Col2).

% Prints the last '-' character of each line 
printHoriLine(_, 0) :-
    write(-),
    nl.

% Skips printing '----'  depending on the current line and row
printHoriLine(Row, Col) :-
    (((Col == 1, (Row == 1; Row == 2; Row == 3; Row == 4;
Row == 6; Row == 7; Row == 8)));
    (Col == 10, (Row == 2; Row == 3; Row == 4; Row == 5; Row == 7; Row == 8; Row == 9))),
    write('    '),
    Col2 is Col - 1,
    printHoriLine(Row, Col2).

% Prints the separating horizontal line
printHoriLine(Row, Col) :-
    write(----),
    Col2 is Col-1,
    printHoriLine(Row, Col2).

% Prints the last horizontal line of the board
printEmptyBoard(0, _) :-
    printHoriLine(10, 10).

% Prints an empty game board
printEmptyBoard(Rows, Cols) :-
    printHoriLine(Rows, Cols),
    printVertLine(Rows, Cols),
    Aux is Rows-1,
    printEmptyBoard(Aux, Cols).