:- use_module(library(ansi_term)).
:- use_module(library(lists)).
:- include('internalstructure.pl').
:- include('utilities.pl').

%When the board is empty, prints the last line delimiter 
%(the consecutive dashes "-----")
print_board([], Row) :-
    print_dashed_line(Row),
    nl.

%Depending on the value or Row, prints the respective dashed line and 
%the line with the board contents
print_board([H|T], Row) :-
    print_dashed_line(Row),
    nl,
    Col is 1,
    print_row(H, Row, Col),
    nl,
    Row2 is Row+1,
    print_board(T, Row2).

%When there are no more columns of the same line to print, 
%prints the last vertical bar
print_row([], _, _) :-
    write('|').

%Depending on the Col of the same Row (Row is constant),  
%prints the respective cell
print_row([H|T], Row, Col) :-
    print_pipe(Row, Col),
    print_cell(H, Row, Col),
    Col2 is Col+1,
    print_row(T, Row, Col2).

%Prints the auxiliary column numbers of the board
print_dashed_line(1) :-
    write('    | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 |10 |'),
    nl,
    write(---------------------------------------------).

%Prints the dashed line that delimits the first and second
%main board rows
print_dashed_line(2) :-
    write('-----   -------------------------------------').

%Prints the dashed line that delimits the nineth and tenth 
%main board rows
print_dashed_line(10) :-
    write('-----------------------------------------    ').

%Prints the full dashed line, characteristic of rows 6 and 11
print_dashed_line(Row) :-
    (   Row==6
    ;   Row==11
    ),
    write(---------------------------------------------).

%Prints an interrupted dashed line
print_dashed_line(Row) :-
    Row\=1,
    Row\=2,
    Row\=6,
    Row\=10,
    Row\=11,
    write('-----   ---------------------------------    ').

%Prints the beggining of the tenth row (the line number and the first pipe)
print_pipe(10, 1) :-
    write(' 10 |').

%Prints the beggining of each row (the line number and the first pipe)
print_pipe(Row, 1) :-
    write('  '),
    write(Row),
    write(' |').

%Prints the pipes of the first row, on columns 2 and 6
print_pipe(1, Col) :-
    (   Col==2
    ;   Col==6
    ),
    write('|').

%Prints the pipes of the tenth row, on columns 6 and 10
print_pipe(10, Col) :-
    (   Col==6
    ;   Col==10
    ),
    write('|').

%Prints the pipes of the rest of the rows
print_pipe(Row, _) :-
    Row\=1,
    Row\=10,
    write('|').

%Stops when all pipes have been written
print_pipe(_, _).

%Prints the corresponding character of a cell, 
%on row 1
print_cell([H|T], 1, Col) :-
    Col\=1,
    Col\=5,
    Col\=10,
    print_character(H, T),
    write(' ').

%Prints the corresponding character of a cell,
%on row 10
print_cell([H|T], 10, Col) :-
    Col\=5,
    Col\=9,
    Col\=10,
    print_character(H, T),
    write(' ').

%Prints the remaining characters of a row
print_cell([H|T], _, _) :-
    print_character(H, T).

%If a cell is a triangle, then it paints it with the color 
%of the player that picked it (up in this case)
print_character('T', [H|T]) :-
    H==up,
    nth1(1, T, X),
    get_color(X, C1),
    nth1(2, T, Y),
    get_color(Y, C2),
    print_triangle_cell(9700, 9698, C1, C2).

%If a cell is a triangle, then it paints it with the color 
%of the player that picked it (down in this case)
print_character('T', [H|T]) :-
    H==dw,
    nth1(1, T, X),
    get_color(X, C1),
    nth1(2, T, Y),
    get_color(Y, C2),
    print_triangle_cell(9699, 9701, C1, C2).

%If a cell is a rectangle, then it paints it with the color 
%of the player that picked it
print_character('R', [_, H|_]) :-
    get_color(H, C1),
    print_square_cell(9632, C1).

%If a cell is a square, then it paints it with the color 
%of the player that picked it
print_character('Q', [H|_]) :-
    get_color(H, C1),
    print_square_cell(9632, C1).

%Paints a square cell with its corresponding color
print_square_cell(Code1, Color1) :-
    write(' '),
    ansi_format([fg(Color1)], '~c', [Code1]),
    write(' ').

%Paints a triangle cell with its corresponding color 
%and selected side
print_triangle_cell(Code1, Code2, Color1, Color2) :-
    ansi_format([fg(Color1)], '~c', [Code1]),
    write(' '),
    ansi_format([fg(Color2)], '~c', [Code2]).

%Sets free cells' color as white
get_color(nill, Color) :-
    Color=white.
%Sets player 1's color as red
get_color(p1, Color) :-
    Color=red.

%Sets player 2's color as blue
get_color(p2, Color) :-
    Color=blue.

%Replaces an element of a list. If the index 
%of the element to be replaced is 0 (the first 
%element of the list), then the resulting list is 
%element X appended to the rest of the list (and 
%excluding the element in index 0 of the original list).
%Note that indexes in this predicate star at 0! 

replace_nth([_|T], 0, X, [X|T]).
%Replaces an element of a list. If the index of the 
%current element is not zero (the index is decreased until 
%the element is found - in this case, the index would be 0),
%then the predicate recursively calls itself again with the 
%same list, but excluding its head.
%Note that indexes in this predicate star at 0! 
replace_nth([H|T], I, X, [H|R]) :-
    I> -1,
    NI is I-1,
    replace_nth(T, NI, X, R), !.

%If the element doesn't exist, it returns the original list
replace_nth(L, _, _, L).

%Iterates the board and gets the line 
%with index=Row
get_line(Board, Row, Line) :-
    nth1(Row, Board, Line).

%Iterates the board and the line with index=Row where the cell 
%is located, and gets the cell in column=Column
get_cell(Board, Row, Column, Cell) :-
    nth1(Row, Board, Line),
    nth1(Column, Line, Cell).

%Paints a rectangle cell by replacing its information with 
%the player that selected it 
paint_cell(Player, Cell, PaintedCell) :-
    nth1(1, Cell, Shape),
    Shape=='R',
    nth1(3, Cell, Owner),
    Owner==nill,
    replace_nth(Cell, 2, Player, PaintedCell).
    
%Paints a square cell by replacing its information with 
%the player that selected it 
paint_cell(Player, Cell, PaintedCell) :-
    nth1(1, Cell, Shape),
    Shape=='Q',
    nth1(2, Cell, Owner),
    Owner==nill,
    replace_nth(Cell, 1, Player, PaintedCell).

%Paints a left triangle cell by replacing its information with 
%the player that selected it and the side of the triangle selected 
paint_cell(Player, Cell, Side, PaintedCell) :-
    nth1(1, Cell, Shape),
    Shape=='T',
    Side==left,
    nth1(3, Cell, Owner),
    Owner==nill,
    replace_nth(Cell, 2, Player, PaintedCell).

%Paints a right triangle cell by replacing its information with 
%the player that selected it and the side of the triangle selected 
paint_cell(Player, Cell, Side, PaintedCell) :-
    nth1(1, Cell, Shape),
    Shape=='T',
    Side==right,
    nth1(4, Cell, Owner),
    Owner==nill,
    replace_nth(Cell, 3, Player, PaintedCell).

%Updates the board by painting the cell existing in
%row=Row and column=Column.
%Note that the cell is not supposed to be a triangle.
%Prints the board when all replacements are done
update_board_single(Player, Row, Column, Board, NewBoard) :-
    get_cell(Board, Row, Column, Cell),
    paint_cell(Player, Cell, PaintedCell),
    get_line(Board, Row, Line),
    DecrementedCol is Column-1,
    replace_nth(Line, DecrementedCol, PaintedCell, NewLine),
    DecrementedRow is Row-1,
    replace_nth(Board, DecrementedRow, NewLine, NewBoard).

%Updates the board by painting the cell existing in
%row=Row and column=Column.
%Note that the cell is supposed to be a triangle, as the 
%predicate receives a Side as parameter. The side can 
%either be left or right
%Prints the board when all replacements are done
update_board_single(Player, Row, Column, Side, Board, NewBoard) :-
    get_cell(Board, Row, Column, Cell),
    paint_cell(Player, Cell, Side, PaintedCell),
    get_line(Board, Row, Line),
    replace_nth(Line, Column-1, PaintedCell, NewLine),
    replace_nth(Board, Row-1, NewLine, NewBoard).

update_board_multiple(Player, List, Board, NewBoard) :- 
    update(Player, List, Board, NewBoard).

update(_, [], Board, Board).

update(Player, [[Row, Column]|T], Board, FinalBoard) :-
    update_board_single(Player, Row, Column, Board, NewBoard),
    update_board_multiple(Player, T, NewBoard, FinalBoard).

%The cell is a triangle if the first element of the cell
%if an T
is_triangle(Cell) :-
    nth1(1, Cell, 'T').

%The cell is a square if the first element of the cell
%if an Q
is_square(Cell) :-
    nth1(1, Cell, 'Q').

%The cell is a rectangle if the first element of the cell
%if an R
is_rectangle(Cell, Id) :-
    nth1(1, Cell, 'R'),
    nth1(2, Cell, Id).

%The side is left if the atom has value left
is_up_side(Char) :-
    Char==left.

is_down_side(Char) :-
    Char==right.

%A side is valid if its value is either left or right
valid_side(Side) :-
    Side==left; Side==right.

valid_coordinate(Coord) :-
    Coord>=1,
    Coord=<10.

rect1squares([[1,2],[1,3],[1,4],[1,5]]).
rect2squares([[1,6],[1,7],[1,8],[1,9],[1,10]]).
rect3squares([[2,10],[3,10],[4,10],[5,10]]).
rect4squares([[6,10],[7,10],[8,10],[9,10],[10,10]]).
rect5squares([[10,9],[10,8],[10,7],[10,6]]).
rect6squares([[10,5],[10,4],[10,3],[10,2],[10,1]]).
rect7squares([[9,1],[8,1],[7,1],[6,1]]).
rect8squares([[5,1],[4,1],[3,1],[2,1],[1,1]]).

get_rect_square_list(Id, List) :-
    it(Id is 1, rect1squares(List)), !;
    it(Id is 2, rect2squares(List)), !;
    it(Id is 3, rect3squares(List)), !;
    it(Id is 4, rect4squares(List)), !;
    it(Id is 5, rect5squares(List)), !;
    it(Id is 6, rect6squares(List)), !;
    it(Id is 7, rect7squares(List)), !;
    it(Id is 8, rect8squares(List)), !.
