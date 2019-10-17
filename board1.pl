:- include('internalstructure.pl').

print_board([], Row) :-
    print_horizontalLine(Row).

print_board([H|T], Row) :-
    print_horizontalLine(Row),
    Col is 1,
    print_row(H, Row, Col),
    nl,
    Row2 is Row+1,
    print_board(T, Row2).

print_row([], Row, Col) :-
    print_verticalLine(Row, Col).

print_row([H|T], Row, Col) :-
    print_verticalLine(Row, Col),
    print_cell(H),
    Col2 is Col+1,
    print_row(T, Row, Col2).

print_horizontalLine(Row) :-
    Row==1,
    write('     | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 |'),
    nl,
    write('     -----------------------------------------').

print_horizontalLine(Row) :-
    Row==11,
    write('     -----------------------------------------').

print_horizontalLine(Row) :-
    (   Row==2
    ;   Row==6
    ),
    write('         -------------------------------------').

print_horizontalLine(Row) :-
    (   Row==5
    ;   Row==10
    ),
    write('     -------------------------------------    ').

print_horizontalLine(Row) :-
    Row\=1,
    Row\=2,
    Row\=5,
    Row\=6,
    Row\=10,
    Row\=11,
    write('        ----------------------------------    ').

print_verticalLine(Row, Col) :-
    Row==1,
    (   Col==1
    ;   Col==2
    ;   Col==6
    ),
    write('|').

print_verticalLine(Row, Col) :-
    Row == 10,
    (Col==1; Col==5 ; Col==10),
    write('|').

print_cell([H|_T]) :-
    write(' '),
    write(H),
    write(' ').
