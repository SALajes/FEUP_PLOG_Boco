:- include('board.pl').

%Clears the screen
cls :- write('\e[2J').

%Prints the game board, starting from row 1
display_game(Board) :-
    print_board(Board, 1).

%Prints the initial, empty board and then 
%executes a play
play :-
    bocoStructure(Board),
    select_game_mode(GameMode),
    display_game(Board),
    first_execute_play(Board, p1, GameMode).

%Player vs Player
%Executes the first play of the game in a Player vs Player
%game mode, by either player 1 or player 2
first_execute_play(Board, Player, GameMode) :-
    cls(),
    GameMode=1,
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
    cls(),
    execute_play(NewBoard, NewPlayer, GameMode).

%Player vs PC - predicate that lets the player make a move
%Executes the first play of the game in a Player vs PC
% game mode, by player 1
first_execute_play(Board, Player, GameMode) :-
    cls(),
    GameMode=2,
    Player=p1,
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
    cls(),
    execute_play(NewBoard, NewPlayer, GameMode).

%Player vs PC - predicate that lets the PC make a move
%Executes the first play of the game in a Player vs PC
% game mode, by player 2
first_execute_play(Board, Player, GameMode) :-
    cls(),
    GameMode=2,
    Player=p2,
    repeat,
    available_plays(Board, [Row-Column-Side|_]),
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
    cls(),
    execute_play(NewBoard, NewPlayer, GameMode).

%PC vs Player - predicate that lets the PC make a move
%Executes the first play of the game in a PC vs Player
% game mode, by player 1
first_execute_play(Board, Player, GameMode) :-
    cls(),
    GameMode=3,
    Player=p1,
    random_between(1, 10, Row),
    random_between(1, 10, Column),
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
    cls(),
    execute_play(NewBoard, NewPlayer, GameMode).

%PC vs Player - predicate that lets the Player make a move
%Executes the first play of the game in a PC vs Player
% game mode, by player 2
first_execute_play(Board, Player, GameMode) :-
    cls(),
    GameMode=3,
    Player=p2,
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
    cls(),
    execute_play(NewBoard, NewPlayer, GameMode).

%PC vs PC
%Executes the first play of the game in a PC vs PC
%game mode, by either Player 1 or Player 2
first_execute_play(Board, Player, GameMode) :-
    cls(),
    GameMode=4,
    random_between(1, 10, Row),
    random_between(1, 10, Column),
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
    sleep(1),
    cls(),
    execute_play(NewBoard, NewPlayer, GameMode).

%Checks if the game mode inserted by the user is one of the 4 valid ones
process_game_mode(GameMode) :-
    repeat,
    read(GameMode),
    ite(between(1, 4, GameMode), !, print_invalid_value()).
%Prints on the screen the "pick game mode" screen, and gets user input
ask_game_mode(GameMode) :-
    writeln("You can pick one of the following modes: "),
    writeln("1. Player vs Player;"),
    writeln("2. Player vs PC;"),
    writeln("3. PC vs Player"),
    writeln("4. PC vs PC"),
    writeln("Please insert the number of the mode you want to play: "),
    read(GameMode).

%Asks the user for a game mode
select_game_mode(GameMode) :-
    ask_game_mode(GameMode).

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

%Lists all available plays on the board. A valid (and, therefore, 
%available) play is one where the selected cell is empty, and has 
%at least one filled adjacent cell
available_plays(Board, PlayList) :-
    findall(X1-Y1,
            valid_cell(Board, X1, Y1),
            L1),
    findall(X2-Y2-left,
            valid_cell(Board, X2, Y2, left),
            L2),
    findall(X3-Y3-right,
            valid_cell(Board, X3, Y3, right),
            L3),
    append(L1, L2, AuxL1),
    append(AuxL1, L3, PlayList).

%Stops printing available plays when the list is empty
print_available_plays([]).

%Prints every available play in the format Row-Column
print_available_plays([X-Y|T]) :-
    write(X),
    write("-"),
    write(Y),
    nl,
    print_available_plays(T).

%Checks if a play inserted by the user is valid.
%To be valid, the coordinates of the cell selected 
%by the user need to exist in the list of available plays 
%called PlayList.
valid_play(Board, Player, Row, Column, Side) :-
    repeat,
    available_plays(Board, PlayList),
    writeln("Available plays:"),
    print_available_plays(PlayList),
    ask_move(Board, [Row, Column, Side], Player),!,
    (member(Row-Column, PlayList);member(Row-Column-Side, PlayList)).

%Player vs Player - lets Player make a move
%Player vs PC - lets Player make a move
%Lets a player make a move if the following scenarios are
%valid:
%-Game mode is Player vs Player
%-Game mode is Player vs PC and it's the Player's turn to play
%-Game mode is PC vs Player and it's the Player's turn to play
execute_play(Board, Player, GameMode) :-
    (   GameMode=1
    ;   GameMode=2,
        Player=p1
    ;   GameMode=3,
        Player=p2
    ),
    valid_play(Board, Player, Row, Column, Side),
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
    sleep(1),
    cls(),
    execute_play(NewBoard, NewPlayer, GameMode).

%Player vs PC - lets PC make a move
%PC vs Player - lets PC make a move
%Lets a PC make a move if the following scenarios are
%valid:
%-Game mode is Player vs PC
%-Game mode is PC vs Player and it's the PC's turn to play
%-Game mode is PC vs PC 
execute_play(Board, Player, GameMode) :-
    (   GameMode=2,
        Player=p2
    ;   GameMode=3,
        Player=p1
    ;   GameMode=4
    ),
    (available_plays(Board, [Row-Column-Side|_]);available_plays(Board, [Row-Column|_])),
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
    sleep(1),
    cls(),
    execute_play(NewBoard, NewPlayer, GameMode).

%Checks if a triangle cell, on a certain side (left or right) is empty
cell_empty(Board, Row, Column, Side) :-
    get_cell(Board, Row, Column, Cell),
    nth1(1, Cell, 'T'),
    (   Side==left,
        nth1(3, Cell, nill)
    ;   Side==right,
        nth1(4, Cell, nill)
    ).

%Checks if a rectangle cell is empty
cell_empty(Board, Row, Column, _) :-
    get_cell(Board, Row, Column, Cell),
    nth1(1, Cell, 'R'),
    nth1(3, Cell, nill).

%Checks if a square cell is empty
cell_empty(Board, Row, Column, _) :-
    get_cell(Board, Row, Column, Cell),
    nth1(1, Cell, 'Q'),
    nth1(2, Cell, nill).

%Checks if a rectangle cell is occupied
cell_occupied(Board, Row, Column) :-
    valid_coordinate(Row),
    valid_coordinate(Column),
    get_cell(Board, Row, Column, Cell),
    nth1(1, Cell, 'R'),
    (   nth1(3, Cell, p1)
    ;   nth1(3, Cell, p2)
    ).
    
%Checks if a square cell is occupied
cell_occupied(Board, Row, Column) :-
    valid_coordinate(Row),
    valid_coordinate(Column),
    get_cell(Board, Row, Column, Cell),
    nth1(1, Cell, 'Q'),
    (   nth1(2, Cell, p1)
    ;   nth1(2, Cell, p2)
    ).

%Checks if a triangle cell, on a certain side, is occupied
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

%Checks if a triangle cell is valid by verifying if it is not owned
%by any Player, and if there is, at least, one adjacent cell that
%has been picked by a Player previously
valid_cell(Board, Row, Column, Side) :-
    get_cell(Board, Row, Column, Cell),
    nth1(1, Cell, 'T'),
    cell_empty(Board, Row, Column, Side),
    (   check_above(Board, Row, Column, Side)
    ;   check_below(Board, Row, Column, Side)
    ;   check_left(Board, Row, Column, Side)
    ;   check_right(Board, Row, Column, Side)
    ).

%Checks if a non-triangle cell is valid by verifying if it is not owned
%by any Player, and if there is, at least, one adjacent cell that
%has been picked by a Player previously
valid_cell(Board, Row, Column) :-
    valid_coordinate(Row),
    valid_coordinate(Column),
    cell_empty(Board, Row, Column, _),
    (   check_above(Board, Row, Column)
    ;   check_below(Board, Row, Column)
    ;   check_left(Board, Row, Column)
    ;   check_right(Board, Row, Column)
    ).

%If a cell is a rectangle, then it will update every cell that is 
%part of it in the board. Else, it will just paint a single square
check_single(Cell, Id, Player, List, Board, NewBoard, Row, Column) :-
    ite(is_rectangle(Cell, Id),
        update_board_multiple(Player, List, Board, NewBoard),
        update_board_single(Player, Row, Column, Board, NewBoard)).