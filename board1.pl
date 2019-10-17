print_board([], Row) :-
    print_horizontalLine(Row).

print_board([H|T], Row) :-
    print_horizontalLine(Row),
    nl,
    Col is 1,
    print_row(H, Row, Col),
    nl,
    Row2 is Row+1,
    print_board(T, Row2).

print_row([], _, _):-
    write('|').

print_row([H|T], Row, Col) :-
    print_verticalLine(Row, Col),
    print_cell(H, Row, Col),
    Col2 is Col+1,
    print_row(T, Row, Col2).

print_horizontalLine(1) :-
    write('    | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 |10 |'),
    nl,
    write('---------------------------------------------').

print_horizontalLine(2) :-
    write('-----   -------------------------------------').

print_horizontalLine(10) :-
    write('-----------------------------------------    ').

print_horizontalLine(Row) :-
    (Row == 6; Row == 11),
    write('---------------------------------------------').

print_horizontalLine(Row) :-
    Row\=1,
    Row\=2,
    Row\=6,
    Row\=10,
    Row\=11,
    write('-----   ---------------------------------    ').

print_verticalLine(10, 1):-
    write('|10 |').

print_verticalLine(Row, 1):-
    write('| '),
    write(Row),
    write(' |').

print_verticalLine(1, Col) :-
    (Col==2; Col==6),
    write('|').

print_verticalLine(10, Col) :-
    (Col==6 ; Col==10),
    write('|').

print_verticalLine(Row,_):-
    Row \= 1,
    Row \= 10,
    write('|').

print_verticalLine(_,_).

print_cell([H|_T], 1, Col) :-
    Col \= 1,
    Col \= 5,
    Col \= 10,
    print_character(H, _T),
    write(' ').

print_cell([H|_T], 10, Col) :-
    Col \= 5,
    Col \= 9,
    Col \= 10,
    print_character(H, _T),
    write(' ').

print_cell([H|_T], _, _) :-
    print_character(H, _T).

print_character('T', [H|T]):-
    H == up,
    write('X'),
    write('/'),
    write('X').

print_character('T', [H|T]):-
    H == dw,
    write('X'),
    write('\\'),
    write('X').

print_character(C, [H|T]):-
    write(' '),
    write(C),
    write(' ').

