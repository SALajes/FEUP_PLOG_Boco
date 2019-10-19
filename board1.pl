:- use_module(library(ansi_term)).

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

print_cell([H|T], 1, Col) :-
    Col \= 1,
    Col \= 5,
    Col \= 10,
    print_character(H, T),
    write(' ').

print_cell([H|T], 10, Col) :-
    Col \= 5,
    Col \= 9,
    Col \= 10,
    print_character(H, T),
    write(' ').

print_cell([H|T], _, _) :-
    print_character(H, T).

print_character('T', [H|T]):-
    H == up,
    nth1(1,T,X),
    getColor(X, C1),
    nth1(2,T,Y),
    getColor(Y, C2),
    print_triangle_cell(9700, 9698, C1, C2).

print_character('T', [H|T]):-
    H == dw,
    nth1(1,T,X),
    getColor(X, C1),
    nth1(2,T,Y),
    getColor(Y, C2),
    print_triangle_cell(9699, 9701, C1, C2).

print_character('R', [_|T]):-
    nth1(1,T,X),
    getColor(X, C1),
    print_square_cell(9632, C1).

print_character('Q', [H|_]):-
    getColor(H, C1),
    print_square_cell(9632, C1).

print_square_cell(Code1, Color1):-
    write(' '),
    ansi_format([fg(Color1)], '~c',[Code1]),
    write(' ').

print_triangle_cell(Code1, Code2, Color1, Color2):-
    ansi_format([fg(Color1)], '~c',[Code1]),
    write(' '),
    ansi_format([fg(Color2)], '~c',[Code2]).

getColor(nill, Color):-
    Color = black.

getColor(p1, Color):-
    Color = red.

getColor(p2, Color):-
    Color = blue.



