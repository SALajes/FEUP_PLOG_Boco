:- include('board.pl').

updateBoard(Board, Player) :-
    print_board(Board, 1), 
    % makeMove(Player, 4, 8, Board, NewBoard),
    makeMove(Player, 9, 2, right, Board, NewBoard),
    print_board(NewBoard, 1).

% Starts the game, printing an empty board
% Need to provide the size of the map (rows and columns)
play :-
    bocoStructure(Board),
    updateBoard(Board, p1).