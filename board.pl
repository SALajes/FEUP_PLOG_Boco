printVertLine(0) :-
    write('|'),
    nl.

printVertLine(Num) :-
    write('|     '),
    Num2 is Num-1,
    printVertLine(Num2).

printHoriLine(0) :-
    write(-----),
    nl.

printHoriLine(Num) :-
    write(-----),
    Num2 is Num-1,
    printHoriLine(Num2).

printEmptyBoard(0, Cols) :-
    printHoriLine(Cols).

printEmptyBoard(Num, Cols) :-
    Aux is Num-1,
    printHoriLine(Cols),
    printVertLine(Cols),
    printVertLine(Cols),
    printEmptyBoard(Aux, Cols).
