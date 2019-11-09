:- include('board.pl').
:- include('utilities.pl').

display_game(Board) :-
    print_board(Board, 1).

process_triangle_cell(Side) :-
    repeat,
    ask_triangle_side(Side),
    ite(valid_side(Side), !, print_invalid_value()).

print_invalid_value :-
    writeln("Invalid value. Please try again."),
    fail.

process_coordinate(Coord) :-
    repeat,
    read(Coord),
    ite(valid_coordinate(Coord), !, print_invalid_value()).

ask_triangle_side(Side) :-
    writeln("Insert the side of the triangle (left or right): "),
    read(Side).

% move(+Move, +Board, -NewBoard).
% makeMove(Player, 4, 8, Board, NewBoard),
ask_move(Board, [Row, Column, Side]) :-
    writeln("Insert the row number: "),
    process_coordinate(Row),
    writeln("Insert the column number: "),
    process_coordinate(Column),
    get_cell(Board, Row, Column, Cell),
    ite(is_triangle(Cell), ask_triangle_side(Side), !).

execute_play(Board) :-
    ask_move(Board, [Row, Column, Side]),
    ite(valid_side(Side),
        update_board(p1, Row, Column, Side, Board, NewBoard),
        update_board(p1, Row, Column, Board, NewBoard)),
    display_game(NewBoard),
    execute_play(NewBoard).

% Starts the game, printing an empty board
% Need to provide the size of the map (rows and columns)
play :-
    bocoStructure(Board),
    display_game(Board),
    execute_play(Board).