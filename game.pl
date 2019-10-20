:- include('board.pl').

display_game(Board, _Player) :-
    % makeMove(Player, 4, 8, Board, NewBoard),
    % makeMove(Player, 2, 3, right, NewBoard, NewBoard2),
    % makeMove(p2, 2, 4, NewBoard2, NewBoard3),
    % makeMove(Player, 3, 4, left, NewBoard3, NewBoard4),
    % makeMove(p2, 3, 4, right, NewBoard4, NewBoard5),
    % makeMove(Player, 3, 5, NewBoard5, NewBoard6),
    print_board(Board, 1).

% Starts the game, printing an empty board
% Need to provide the size of the map (rows and columns)
play :-
    initialBoard(Board),
    display_game(Board, p1).