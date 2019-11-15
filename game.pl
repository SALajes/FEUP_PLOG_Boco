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

display_available_plays(Board, PlayList) :-
    findall(X1-Y1, valid_cell(Board, X1, Y1), L1),
    findall(X2-Y2, valid_cell(Board, X2, Y2, left), L2),
    findall(X3-Y3, valid_cell(Board, X3, Y3, right), L3),
    append(L1, L2, AuxL1),
    append(AuxL1, L3, PlayList).

first_execute_play(Board, Player) :-
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

print_available_plays([]).

print_available_plays([X-Y|T]) :-
    write(X), write("-"), write(Y), nl,
    print_available_plays(T).

%Asks the player for a move, and then updates the board 
%depending if the selected cell is a triangle or not.
%After that, repeats.
execute_play(Board, Player) :-
    display_available_plays(Board, PlayList),
    print_available_plays(PlayList),
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

cell_empty(Board, Row, Column, Side) :-
    get_cell(Board, Row, Column, Cell),
    nth1(1, Cell, 'T'),
    (   Side==left,
        nth1(3, Cell, nill)
    ;   Side==right,
        nth1(4, Cell, nill)
    ).

cell_empty(Board, Row, Column, _) :-
    get_cell(Board, Row, Column, Cell),
    nth1(1, Cell, 'R'),
    nth1(3, Cell, nill).

cell_empty(Board, Row, Column, _) :-
    get_cell(Board, Row, Column, Cell),
    nth1(1, Cell, 'Q'),
    nth1(2, Cell, nill).

cell_occupied(Board, Row, Column) :-
    valid_coordinate(Row),
    valid_coordinate(Column),
    get_cell(Board, Row, Column, Cell),
    nth1(1, Cell, 'R'),
    (   nth1(3, Cell, p1)
    ;   nth1(3, Cell, p2)
    ).
    
cell_occupied(Board, Row, Column) :-
    valid_coordinate(Row),
    valid_coordinate(Column),
    get_cell(Board, Row, Column, Cell),
    nth1(1, Cell, 'Q'),
    (   nth1(2, Cell, p1)
    ;   nth1(2, Cell, p2)
    ).

cell_occupied(Board, Row, Column, Side) :-
    valid_coordinate(Row),
    valid_coordinate(Column),
    get_cell(Board, Row, Column, Cell),
    nth1(1, Cell, 'T'),
    (   Side==left,
        (   nth1(3, Cell, p1)
        ;   nth1(3, Cell, p2)
        )
    ;   Side==right,
        (   nth1(4, Cell, p1)
        ;   nth1(4, Cell, p2)
        )
    ).

%If selected cell is up triangle right side, then above cell is the other half of triangle 
check_above(Board, Row, Column, Side) :-
    NewRow is Row-1,
    valid_coordinate(NewRow),
    get_cell(Board, Row, Column, Cell),
    nth1(2, Cell, up),
    Side==right,
    cell_occupied(Board, Row, Column, left).

%If selected cell is up triangle, checks if above cell is rectangle or square
check_above(Board, Row, Column, Side) :-
    NewRow is Row-1,
    valid_coordinate(NewRow),
    get_cell(Board, Row, Column, Cell),
    nth1(2, Cell, up),
    Side==left,
    get_cell(Board, NewRow, Column, AboveCell),
    (   nth1(1, AboveCell, 'R')
    ;   nth1(1, AboveCell, 'Q')
    ),
    cell_occupied(Board, NewRow, Column).

%If selected cell is down triangle, checks if above cell is a square or a rectangle
check_above(Board, Row, Column, Side) :-
    NewRow is Row-1,
    valid_coordinate(NewRow),
    get_cell(Board, Row, Column, Cell),
    nth1(2, Cell, dw),
    Side==right,
    get_cell(Board, Row, Column, AboveCell),
    (   nth1(1, AboveCell, 'R')
    ;   nth1(1, AboveCell, 'Q')
    ),
    cell_occupied(Board, NewRow, Column).

%If selected cell is down triangle, then above cell is the other half of the triangle
check_above(Board, Row, Column, Side) :-
    NewRow is Row-1,
    valid_coordinate(NewRow),
    get_cell(Board, Row, Column, Cell),
    nth1(2, Cell, dw),
    Side==left,
    cell_occupied(Board, Row, Column, right).

%If selected cell is square, checks if above cell is rectangle
check_above(Board, Row, Column) :-
    NewRow is Row-1,
    valid_coordinate(NewRow),
    get_cell(Board, Row, Column, Cell),
    nth1(1, Cell, 'Q'),
    get_cell(Board, NewRow, Column, AboveCell),
    nth1(1, AboveCell, 'R'),
    cell_occupied(Board, NewRow, Column).

%If selected cell is square, checks if above cell is up triangle
check_above(Board, Row, Column) :-
    NewRow is Row-1,
    valid_coordinate(NewRow),
    get_cell(Board, Row, Column, Cell),
    nth1(1, Cell, 'Q'),
    get_cell(Board, NewRow, Column, AboveCell),
    nth1(2, AboveCell, up),
    cell_occupied(Board, NewRow, Column, right).

%If selected cell is square, checks if above cell is down triangle
check_above(Board, Row, Column) :-
    NewRow is Row-1,
    valid_coordinate(NewRow),
    get_cell(Board, Row, Column, Cell),
    nth1(1, Cell, 'Q'),
    get_cell(Board, NewRow, Column, AboveCell),
    nth1(2, AboveCell, down),
    cell_occupied(Board, NewRow, Column, left).

%If selected cell is rectangle, checks if above cell is rectangle
check_above(Board, Row, Column) :-
    NewRow is Row-1,
    valid_coordinate(NewRow),
    get_cell(Board, Row, Column, Cell),
    nth1(1, Cell, 'R'),
    get_cell(Board, NewRow, Column, AboveCell),
    nth1(1, AboveCell, 'R'),
    cell_occupied(Board, NewRow, Column).

%If selected cell is rectangle, checks if above cell is square
check_above(Board, Row, Column) :-
    NewRow is Row-1,
    valid_coordinate(NewRow),
    get_cell(Board, Row, Column, Cell),
    nth1(1, Cell, 'R'),
    get_cell(Board, NewRow, Column, AboveCell),
    nth1(1, AboveCell, 'Q'),
    cell_occupied(Board, NewRow, Column).

%If selected cell is rectangle, checks if above cell is down triangle
check_above(Board, Row, Column) :-
    NewRow is Row-1,
    valid_coordinate(NewRow),
    get_cell(Board, Row, Column, Cell),
    nth1(1, Cell, 'R'),
    get_cell(Board, NewRow, Column, AboveCell),
    nth1(2, AboveCell, down),
    cell_occupied(Board, NewRow, Column, right).

%If selected cell is up triangle right side, checks if down cell is rectangle or square
check_below(Board, Row, Column, Side) :-
    NewRow is Row+1,
    valid_coordinate(NewRow),
    get_cell(Board, Row, Column, Cell),
    nth1(2, Cell, up),
    Side==right,
    get_cell(Board, NewRow, Column, BelowCell),
    (   nth1(1, BelowCell, 'Q')
    ;   nth1(1, BelowCell, 'R')
    ),
    cell_occupied(Board, NewRow, Column).

%If selected cell is up triangle left side, then below cell is the other half of the triangle
check_below(Board, Row, Column, Side) :-
    NewRow is Row+1,
    valid_coordinate(NewRow),
    get_cell(Board, Row, Column, Cell),
    nth1(2, Cell, up),
    Side==left,
    cell_occupied(Board, Row, Column, right).

%If selected cell is down triangle right side, then below cell is the other half of the triangle
check_below(Board, Row, Column, Side) :-
    NewRow is Row+1,
    valid_coordinate(NewRow),
    get_cell(Board, Row, Column, Cell),
    nth1(2, Cell, dw),
    Side==right,
    cell_occupied(Board, Row, Column, left).

%If selected cell is down triangle left side, then below cell is either rectangle or square
check_below(Board, Row, Column, Side) :-
    NewRow is Row+1,
    valid_coordinate(NewRow),
    get_cell(Board, Row, Column, Cell),
    nth1(2, Cell, dw),
    Side==left,
    get_cell(Board, NewRow, Column, BelowCell),
    (   nth1(1, BelowCell, 'Q')
    ;   nth1(1, BelowCell, 'R')
    ),
    cell_occupied(Board, NewRow, Column, _).

%If selected cell is square, checks if below cell is rectangle
check_below(Board, Row, Column) :-
    NewRow is Row+1,
    valid_coordinate(NewRow),
    get_cell(Board, Row, Column, Cell),
    nth1(1, Cell, 'Q'),
    get_cell(Board, NewRow, Column, BelowCell),
    nth1(1, BelowCell, 'R'),
    cell_occupied(Board, NewRow, Column).

%If selected cell is square, checks if below cell is up triangle
check_below(Board, Row, Column) :-
    NewRow is Row+1,
    valid_coordinate(NewRow),
    get_cell(Board, Row, Column, Cell),
    nth1(1, Cell, 'Q'),
    get_cell(Board, NewRow, Column, BelowCell),
    nth1(2, BelowCell, up),
    cell_occupied(Board, NewRow, Column, left).

%If selected cell is square, checks if below cell is down triangle
check_below(Board, Row, Column) :-
    NewRow is Row+1,
    valid_coordinate(NewRow),
    get_cell(Board, Row, Column, Cell),
    nth1(1, Cell, 'Q'),
    get_cell(Board, NewRow, Column, BelowCell),
    nth1(2, BelowCell, dw),
    cell_occupied(Board, NewRow, Column, right).

%If selected cell is rectangle, checks if below cell is square or rectangle
check_below(Board, Row, Column) :-
    NewRow is Row+1,
    valid_coordinate(NewRow),
    get_cell(Board, Row, Column, Cell),
    nth1(1, Cell, 'R'),
    get_cell(Board, NewRow, Column, BelowCell),
    (   nth1(1, BelowCell, 'Q')
    ;   nth1(1, BelowCell, 'R')
    ),
    cell_occupied(Board, NewRow, Column).

%If selected cell is rectangle, checks if below cell is 
check_below(Board, Row, Column) :-
    NewRow is Row+1,
    valid_coordinate(NewRow),
    get_cell(Board, Row, Column, Cell),
    nth1(1, Cell, 'R'),
    get_cell(Board, NewRow, Column, BelowCell),
    nth1(2, BelowCell, up),
    cell_occupied(Board, NewRow, Column, left).

%If selected cell is triangle and side is left, then left cell is either rectangle or square
check_left(Board, Row, Column, Side) :-
    NewColumn is Column-1,
    valid_coordinate(NewColumn),
    Side==left,
    cell_occupied(Board, Row, NewColumn).

%If selected cell is triangle and side is right, then left cell is other half of the triangle
check_left(Board, Row, Column, Side) :-
    NewColumn is Column-1,
    valid_coordinate(NewColumn),
    Side==right,
    cell_occupied(Board, Row, Column, left).

%If selected cell is square, checks if left cell is rectangle
check_left(Board, Row, Column) :-
    NewColumn is Column-1,
    valid_coordinate(NewColumn),
    get_cell(Board, Row, Column, Cell),
    nth1(1, Cell, 'Q'),
    get_cell(Board, Row, NewColumn, LeftCell),
    nth1(1, LeftCell, 'R'),
    cell_occupied(Board, Row, NewColumn).

%If selected cell is square, checks if left cell is triangle
check_left(Board, Row, Column) :-
    NewColumn is Column-1,
    valid_coordinate(NewColumn),
    get_cell(Board, Row, Column, Cell),
    nth1(1, Cell, 'Q'),
    get_cell(Board, Row, NewColumn, LeftCell),
    nth1(1, LeftCell, 'T'),
    cell_occupied(Board, Row, NewColumn, right).

%If selected cell is rectangle, checks if left cell is either rectangle or square
check_left(Board, Row, Column) :-
    NewColumn is Column-1,
    valid_coordinate(NewColumn),
    get_cell(Board, Row, Column, Cell),
    nth1(1, Cell, 'R'),
    get_cell(Board, Row, NewColumn, LeftCell),
    (   nth1(1, LeftCell, 'R')
    ;   nth1(1, LeftCell, 'Q')
    ),
    cell_occupied(Board, Row, NewColumn).

%If selected cell is rectangle, checks if left cell is triangle
check_left(Board, Row, Column) :-
    NewColumn is Column-1,
    valid_coordinate(NewColumn),
    get_cell(Board, Row, Column, Cell),
    nth1(1, Cell, 'R'),
    get_cell(Board, Row, NewColumn, LeftCell),
    nth1(1, LeftCell, 'T'),
    cell_occupied(Board, Row, NewColumn, right).

%If selected cell is triangle right side, checks if right cell is either rectangle or square
check_right(Board, Row, Column, Side) :-
    NewColumn is Column+1,
    valid_coordinate(NewColumn),
    Side==right,
    get_cell(Board, Row, NewColumn, RightCell),
    (   nth1(1, RightCell, 'Q')
    ;   nth1(1, RightCell, 'R')
    ),
    cell_occupied(Board, Row, NewColumn).

%If selected cell is triangle left side, then right cell is the other half of triangle 
check_right(Board, Row, Column, Side) :-
    NewColumn is Column+1,
    valid_coordinate(NewColumn),
    Side==left,
    cell_occupied(Board, Row, Column, right).

%If selected cell is square, checks if right cell is rectangle
check_right(Board, Row, Column) :-
    NewColumn is Column+1,
    valid_coordinate(NewColumn),
    get_cell(Board, Row, Column, Cell),
    nth1(1, Cell, 'Q'),
    get_cell(Board, Row, NewColumn, RightCell),
    nth1(1, RightCell, 'R'),
    cell_occupied(Board, Row, NewColumn).

%If selected cell is square, checks if right cell is triangle
check_right(Board, Row, Column) :-
    NewColumn is Column+1,
    valid_coordinate(NewColumn),
    get_cell(Board, Row, Column, Cell),
    nth1(1, Cell, 'Q'),
    get_cell(Board, Row, NewColumn, RightCell),
    nth1(1, RightCell, 'T'),
    cell_occupied(Board, Row, NewColumn, left).

%If selected cell is rectangle, checks if right cell is either rectangle or square
check_right(Board, Row, Column) :-
    NewColumn is Column+1,
    valid_coordinate(NewColumn),
    get_cell(Board, Row, Column, Cell),
    nth1(1, Cell, 'R'),
    get_cell(Board, Row, NewColumn, RightCell),
    (   nth1(1, RightCell, 'R')
    ;   nth1(1, RightCell, 'Q')
    ),
    cell_occupied(Board, Row, NewColumn).

%If selected cell is rectangle, checks if right cell is triangle
check_right(Board, Row, Column) :-
    NewColumn is Column+1,
    valid_coordinate(NewColumn),
    get_cell(Board, Row, Column, Cell),
    nth1(1, Cell, 'R'),
    get_cell(Board, Row, NewColumn, RightCell),
    nth1(1, RightCell, 'T'),
    cell_occupied(Board, Row, NewColumn, left).

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
    valid_coordinate(Row),
    valid_coordinate(Column),
    cell_empty(Board, Row, Column, _),
    (   check_above(Board, Row, Column)
    ;   check_below(Board, Row, Column)
    ;   check_left(Board, Row, Column)
    ;   check_right(Board, Row, Column)
    ).

check_single(Cell, Id, Player, List, Board, NewBoard, Row, Column) :-
    ite(is_rectangle(Cell, Id),
        update_board_multiple(Player, List, Board, NewBoard),
        update_board_single(Player, Row, Column, Board, NewBoard)).

valid_moves(Board, AuxList) :-
    findall(X-Y,
            valid_cell(Board, X, Y),
            AuxList).

%Prints the initial, empty board and then 
%executes a play
play :-
    bocoStructure(Board),
    display_game(Board),
    first_execute_play(Board, p1).

teste(L) :-
    findall(X-Y,
            valid_cell(
                       [ 
                         [ ['R', 8, nill],
                           ['R', 1, nill],
                           ['R', 1, nill],
                           ['R', 1, nill],
                           ['R', 1, nill],
                           ['R', 2, nill],
                           ['R', 2, nill],
                           ['R', 2, nill],
                           ['R', 2, nill],
                           ['R', 2, nill]
                         ],
                         
                         [ ['R', 8, nill],
                           ['Q', nill],
                           ['T', dw, nill, nill],
                           ['Q', nill],
                           ['T', dw, nill, nill],
                           ['Q', nill],
                           ['T', dw, nill, nill],
                           ['Q', nill],
                           ['T', dw, nill, nill],
                           ['R', 3, nill]
                         ],
                         
                         [ ['R', 8, nill],
                           ['T', up, nill, nill],
                           ['Q', nill],
                           ['T', up, nill, nill],
                           ['Q', nill],
                           ['T', up, nill, nill],
                           ['Q', nill],
                           ['T', up, nill, nill],
                           ['Q', nill],
                           ['R', 3, nill]
                         ],
                         
                         [ ['R', 8, nill],
                           ['Q', nill],
                           ['T', dw, nill, nill],
                           ['Q', p1],
                           ['T', dw, p2, p1],
                           ['Q', nill],
                           ['T', dw, nill, nill],
                           ['Q', nill],
                           ['T', dw, nill, nill],
                           ['R', 3, nill]
                         ],
                         
                         [ ['R', 8, nill],
                           ['T', up, nill, nill],
                           ['Q', nill],
                           ['T', up, p2, p1],
                           ['Q', nill],
                           ['T', up, nill, nill],
                           ['Q', nill],
                           ['T', up, nill, nill],
                           ['Q', nill],
                           ['R', 3, nill]
                         ],
                         
                         [ ['R', 7, nill],
                           ['Q', nill],
                           ['T', dw, nill, nill],
                           ['Q', p2],
                           ['T', dw, p1, p2],
                           ['Q', nill],
                           ['T', dw, nill, nill],
                           ['Q', nill],
                           ['T', dw, nill, nill],
                           ['R', 4, nill]
                         ],
                         
                         [ ['R', 7, nill],
                           ['T', up, nill, nill],
                           ['Q', nill],
                           ['T', up, nill, nill],
                           ['Q', p1],
                           ['T', up, nill, nill],
                           ['Q', nill],
                           ['T', up, nill, nill],
                           ['Q', nill],
                           ['R', 4, nill]
                         ],
                         
                         [ ['R', 7, nill],
                           ['Q', nill],
                           ['T', dw, nill, nill],
                           ['Q', nill],
                           ['T', dw, nill, nill],
                           ['Q', nill],
                           ['T', dw, nill, nill],
                           ['Q', nill],
                           ['T', dw, nill, nill],
                           ['R', 4, nill]
                         ],
                         
                         [ ['R', 7, nill],
                           ['T', up, nill, nill],
                           ['Q', nill],
                           ['T', up, nill, nill],
                           ['Q', nill],
                           ['T', up, nill, nill],
                           ['Q', nill],
                           ['T', up, nill, nill],
                           ['Q', nill],
                           ['R', 4, nill]
                         ],
                         
                         [ ['R', 6, nill],
                           ['R', 6, nill],
                           ['R', 6, nill],
                           ['R', 6, nill],
                           ['R', 6, nill],
                           ['R', 5, nill],
                           ['R', 5, nill],
                           ['R', 5, nill],
                           ['R', 5, nill],
                           ['R', 4, nill]
                         ]
                       ],
                       X,
                       Y, left),
            L).