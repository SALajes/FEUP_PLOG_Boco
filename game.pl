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