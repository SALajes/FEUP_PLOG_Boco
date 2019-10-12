even(X) :-
    0 is X mod 2.
odd(X) :-
    1 is X mod 2.

printVertLine(_, 0) :-
    write('|'),
    nl.

printVertLine(Row, _Col) :-
    Row == 10,
    write('|   |               |                   |'),
    nl.

printVertLine(Row, _Col) :-
    Row == 1,
    write('|               |                   |   |'),
    nl.

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

printVertLine(Row, Col) :-
    write('|   '),
    Col2 is Col-1,
    printVertLine(Row, Col2).


printVertLine(Row, Col) :-
    write('|   '),
    Col2 is Col-1,
    printVertLine(Row, Col2).

printHoriLine(_, 0) :-
    write(-),
    nl.

printHoriLine(Row, Col) :-
    (((Col == 1, (Row == 1; Row == 2; Row == 3; Row == 4;
Row == 6; Row == 7; Row == 8)));
    (Col == 10, (Row == 2; Row == 3; Row == 4; Row == 5; Row == 7; Row == 8; Row == 9))),
    write('    '),
    Col2 is Col - 1,
    printHoriLine(Row, Col2).

printHoriLine(Row, Col) :-
    write(----),
    Col2 is Col-1,
    printHoriLine(Row, Col2).

printEmptyBoard(0, _) :-
    printHoriLine(10, 10).

printEmptyBoard(Rows, Cols) :-
    printHoriLine(Rows, Cols),
    printVertLine(Rows, Cols),
    Aux is Rows-1,
    printEmptyBoard(Aux, Cols).