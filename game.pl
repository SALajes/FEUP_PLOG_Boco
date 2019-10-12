:- include('board.pl').

% Starts the game, printing an empty board
% Need to provide the size of the map (rows and columns)
start() :-
    printEmptyBoard(10, 10).