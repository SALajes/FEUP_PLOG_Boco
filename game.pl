:- include('board.pl').

%Prints the game board, starting from row 1
display_game(Board) :-
    print_board(Board, 1).

%Checks if the side of the triangle the user inputted is valid
process_triangle_cell(Side) :-
    repeat,
    ask_triangle_side(Side),
    ite(valid_side(Side), !, print_invalid_value()).

%Prints an error message if the coordinate value is invalid
print_invalid_value :-
    writeln("Invalid value. Please try again."),
    fail.

%Checks if a coordinate is valid
process_coordinate(Coord) :-
    repeat,
    read(Coord),
    ite(valid_coordinate(Coord), !, print_invalid_value()).

%Writes text asking for the side of the triangle, and gets 
%that input
ask_triangle_side(Side) :-
    writeln("Insert the side of the triangle (left or right): "),
    read(Side).

%Writes text asking for row, column and possibly side
%of triangle, it it's the cell that the user picked
ask_move(Board, [Row, Column, Side], Player) :-
    ite(Player==p1, writeln("Player 1's turn"), writeln("Player 2's turn")),
    writeln("Insert the row number: "),
    process_coordinate(Row),
    writeln("Insert the column number: "),
    process_coordinate(Column),
    get_cell(Board, Row, Column, Cell),
    ite(is_triangle(Cell), ask_triangle_side(Side), !).

%Asks the player for a move, and then updates the board 
%depending if the selected cell is a triangle or not.
%After that, repeats.
execute_play(Board, Player) :-
    ask_move(Board, [Row, Column, Side], Player),
    get_cell(Board, Row, Column, Cell),
    ite(is_rectangle(Cell, Id),
        get_rect_square_list(Id, List),
        !),
    ite(valid_side(Side),
        update_board_single(Player,
                            Row,
                            Column,
                            Side,
                            Board,
                            NewBoard),
        check_single(Cell,
                     Id,
                     Player,
                     List,
                     Board,
                     NewBoard,
                     Row,
                     Column)),
    print_board(NewBoard, 1),
    ite(Player==p1, NewPlayer=p2, NewPlayer=p1),
    execute_play(NewBoard, NewPlayer).

cell_empty(Board, Row, Column) :-
    valid_coordinate(Row),
    valid_coordinate(Column),
    get_cell(Board, Row, Column, Cell),
    nth1(1, Cell, 'R'),
    nth1(3, Cell, nill).

cell_empty(Board, Row, Column) :-
    valid_coordinate(Row),
    valid_coordinate(Column),
    get_cell(Board, Row, Column, Cell),
    nth1(1, Cell, 'Q'),
    nth1(2, Cell, nill).

cell_empty(Board, Row, Column, Side) :-
    valid_coordinate(Row),
    valid_coordinate(Column),
    get_cell(Board, Row, Column, Cell),
    nth1(1, Cell, 'T'),
    (   Side==left,
        nth1(3, Cell, nill)
    ;   Side==right,
        nth1(4, Cell, nill)
    ).
    
%When a triangle is of type 'up', checks if the cell above Cell is
%valid to be selected.
check_above(Board, Row, Column, Side) :-
    NewRow is Row-1,
    valid_coordinate(NewRow),
    get_cell(Board, Row, Column, Cell),
    nth1(2, Cell, up),
    ite(Side==right,
        \+cell_empty(Board, Row, Column, left),
        it(Side==left, \+cell_empty(Board, NewRow, Column))).

check_above(Board, Row, Column, Side) :-
    NewRow is Row-1,
    valid_coordinate(NewRow),
    get_cell(Board, Row, Column, Cell),
    nth1(2, Cell, dw),
    ite(Side==right,
        \+cell_empty(Board, NewRow, Column),
        it(Side==left, \+cell_empty(Board, Row, Column, right))).

check_above(Board, Row, Column) :-
    NewRow is Row-1,
    valid_coordinate(NewRow),
    get_cell(Board, Row, Column, Cell),
    nth1(1, Cell, 'Q'),
    get_cell(Board, NewRow, Column, AboveCell),
    ite(nth1(1, AboveCell, 'R'),
        \+cell_empty(Board, NewRow, Column),
        ite(nth1(2, AboveCell, up),
            \+cell_empty(Board, NewRow, Column, right),
            \+cell_empty(Board, NewRow, Column, left))).

check_above(Board, Row, Column) :-
    NewRow is Row-1,
    valid_coordinate(NewRow),
    get_cell(Board, Row, Column, Cell),
    nth1(1, Cell, 'R'),
    get_cell(Board, NewRow, Column, AboveCell),
    nth1(1, AboveCell, 'R'),
    \+cell_empty(Board, NewRow, Column).

check_above(Board, Row, Column) :-
    NewRow is Row-1,
    valid_coordinate(NewRow),
    get_cell(Board, Row, Column, Cell),
    nth1(1, Cell, 'R'),
    get_cell(Board, NewRow, Column, AboveCell),
    ite(nth1(1, AboveCell, 'Q'),
        \+cell_empty(Board, NewRow, Column),
        \+cell_empty(Board, NewRow, Column, right)).

check_below(Board, Row, Column, Side) :-
    NewRow is Row+1,
    valid_coordinate(NewRow),
    get_cell(Board, Row, Column, Cell),
    nth1(2, Cell, up),
    ite(Side==right,
        \+cell_empty(Board, NewRow, Column),
        it(Side==left, \+cell_empty(Board, Row, Column, right))).

check_below(Board, Row, Column, Side) :-
    NewRow is Row+1,
    valid_coordinate(NewRow),
    get_cell(Board, Row, Column, Cell),
    nth1(2, Cell, dw),
    ite(Side==right,
        \+cell_empty(Board, NewRow, Column, left),
        it(Side==left, \+cell_empty(Board, Row, Column))).

check_below(Board, Row, Column) :-
    NewRow is Row+1,
    valid_coordinate(NewRow),
    get_cell(Board, Row, Column, Cell),
    nth1(1, Cell, 'Q'),
    get_cell(Board, NewRow, Column, BelowCell),
    ite(nth1(1, BelowCell, 'R'),
        \+cell_empty(Board, NewRow, Column),
        ite(nth1(2, BelowCell, up),
            \+cell_empty(Board, NewRow, Column, left),
            \+cell_empty(Board, NewRow, Column, right))).

check_below(Board, Row, Column) :-
    NewRow is Row+1,
    valid_coordinate(NewRow),
    get_cell(Board, Row, Column, Cell),
    nth1(1, Cell, 'R'),
    get_cell(Board, NewRow, Column, BelowCell),
    ite(nth1(1, BelowCell, 'Q'),
        \+cell_empty(Board, NewRow, Column),
        \+cell_empty(Board, NewRow, Column, right)).

check_below(Board, Row, Column) :-
    NewRow is Row+1,
    valid_coordinate(NewRow),
    get_cell(Board, Row, Column, Cell),
    nth1(1, Cell, 'R'),
    get_cell(Board, NewRow, Column, BelowCell),
    nth1(1, BelowCell, 'R'),
    \+cell_empty(Board, NewRow, Column).

check_left(Board, Row, Column, Side) :-
    NewColumn is Column-1,
    valid_coordinate(NewColumn),
    ite(Side==left,
        \+cell_empty(Board, Row, NewColumn),
        \+cell_empty(Board, Row, Column, left)).

check_left(Board, Row, Column) :-
    NewColumn is Column-1,
    valid_coordinate(NewColumn),
    get_cell(Board, Row, Column, Cell),
    nth1(1, Cell, 'Q'),
    get_cell(Board, Row, NewColumn, LeftCell),
    ite(nth1(1, LeftCell, 'R'),
        \+cell_empty(Board, Row, NewColumn),
        \+cell_empty(Board, Row, NewColumn, right)).


check_left(Board, Row, Column) :-
    NewColumn is Column-1,
    valid_coordinate(NewColumn),
    get_cell(Board, Row, Column, Cell),
    nth1(1, Cell, 'R'),
    get_cell(Board, Row, NewColumn, LeftCell),
    ite((nth1(1, LeftCell, 'R');nth1(1, LeftCell, 'Q')),
        \+cell_empty(Board, Row, NewColumn),
        \+cell_empty(Board, Row, NewColumn, right)).

check_right(Board, Row, Column, Side) :-
    NewColumn is Column+1,
    valid_coordinate(NewColumn),
    ite(Side==right,
        \+cell_empty(Board, Row, NewColumn),
        \+cell_empty(Board, Row, Column, right)).

check_right(Board, Row, Column) :-
    NewColumn is Column+1,
    valid_coordinate(NewColumn),
    get_cell(Board, Row, Column, Cell),
    nth1(1, Cell, 'Q'),
    get_cell(Board, Row, NewColumn, RightCell),
    ite(nth1(1, RightCell, 'R'),
        \+cell_empty(Board, Row, NewColumn),
        \+cell_empty(Board, Row, NewColumn, left)).

check_right(Board, Row, Column) :-
    NewColumn is Column+1,
    valid_coordinate(NewColumn),
    get_cell(Board, Row, Column, Cell),
    nth1(1, Cell, 'R'),
    get_cell(Board, Row, NewColumn, RightCell),
    ite((nth1(1, RightCell, 'R');nth1(1, RightCell, 'Q')),
        \+cell_empty(Board, Row, NewColumn),
        \+cell_empty(Board, Row, NewColumn, left)).

valid_cell(Board, Row, Column, Side) :-
    get_cell(Board, Row, Column, Cell),
    nth1(1, Cell, 'T'),
    cell_empty(Board, Row, Column, Side),
    (   check_above(Board, Row, Column, Side)
    ;   check_below(Board, Row, Column, Side)
    ;   check_left(Board, Row, Column, Side)
    ;   check_right(Board, Row, Column, Side)
    ).

valid_cell(Board, Row, Column) :-
    cell_empty(Board, Row, Column),
    (   check_above(Board, Row, Column)
    ;   check_below(Board, Row, Column)
    ;   check_left(Board, Row, Column)
    ;   check_right(Board, Row, Column)
    ).

check_single(Cell, Id, Player, List, Board, NewBoard, Row, Column) :-
    ite(is_rectangle(Cell, Id),
        update_board_multiple(Player, List, Board, NewBoard),
        update_board_single(Player, Row, Column, Board, NewBoard)).

%Prints the initial, empty board and then 
%executes a play
play :-
    bocoStructure(Board),
    display_game(Board),
    execute_play(Board, p1).