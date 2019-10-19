:- include('board.pl').

updateBoard(Board, Player) :-
    % makeMove(Player, 4, 8, Board, NewBoard),
    makeMove(Player, 2, 3, right, Board, NewBoard),
    makeMove(p2, 2, 4, NewBoard, NewBoard1),
    makeMove(Player, 3, 4, left, NewBoard1, NewBoard2),
    makeMove(p2, 3, 4, right, NewBoard2, NewBoard3),
    makeMove(Player, 3, 5, NewBoard3, NewBoard4),
    print_board(NewBoard4, 1).

% Starts the game, printing an empty board
% Need to provide the size of the map (rows and columns)
play :-
    bocoStructure(Board),
    updateBoard(Board, p1).