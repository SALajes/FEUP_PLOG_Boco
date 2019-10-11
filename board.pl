printVertLine(0) :-
    write(│),
    nl.

printVertLine(Rows) :-
    write('│     '),
    Rows2 is Rows-1,
    printVertLine(Rows2).

printHoriLine(0) :-
    write(─────),
    write(─────),
    nl.

printHoriLine(Rows) :-
    write(─────),
    Rows2 is Rows-1,
    printHoriLine(Rows2).

printEmptyBoard(0, Cols) :-
    printHoriLine(Cols).

printEmptyBoard(Rows, Cols) :-
    Aux is Rows-1,
    printHoriLine(Cols),
    printVertLine(Cols),
    printVertLine(Cols),
    printEmptyBoard(Aux, Cols).
