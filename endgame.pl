%CELL WAS PLAYED, LETS CHECK IF GAME IS OVER

%CellInfo contains ['T', ROW, COLUMN, N, ORIENTATION OF TRIANGLE DIAGONAL, PLAYER] for triangles
game_over(Board, ['T'|T], Row, Col, Side, Player, Finish):-
    nth1(1, T, Orientation),
    convertSide(Side,N),
    startVerification(Board, ['T', Row, Col, N, Orientation, Player], Player, Finish),
    !.

%we receive the side using left and right in the main cycle, but in this verification is more useful to use 1 and 2, so we convert
convertSide(left,1). 
convertSide(right,2).

%CellInfo contains ['Q', ROW, COLUMN, PLAYER] for squares
game_over(Board, ['Q'|_], Row, Col, _, Player, Finish):-
    startVerification(Board, ['Q', Row, Col, Player], Player, Finish),
    !.

%CellInfo contains ['R', ROW, COLUMN, ID, PLAYER] for squares
game_over(Board, ['R'|T], Row, Col, _, Player, Finish):-
    nth1(1, T, ID),
    startVerification(Board, ['R', Row, Col, ID, Player], Player, Finish),
    !.


%START VERIFICATION
startVerification(Board, Coordinates, Player, Finish):-
    playerLost(Board, Coordinates, Player, [], Lost), %VERIFY IF PLAYER LOST
    playerWon(Board, Coordinates, Player, Won), %VERIFY IF PLAYER WIN
    getResult(Player, Lost, Won, Finish). %FINAL JUDGEMENT

getResult(Player, lost, notWon, yes):- 
    oppositePlayer(Player, OppositePlayer),
    playerColor(OppositePlayer, Color), 
    ansi_format([fg(Color)], 'ITS A WIN!!!', []). %THE OPPOSITE PLAYER WAS THE WINNER, SO WE PRINT THE MESSAGE IN THE RESPECTIVE COLOR

getResult(Player, notLost, won, yes):-
    playerColor(Player, Color),
    ansi_format([fg(Color)], 'ITS A WIN!!!', []). %THE PLAYER WAS THE WINNER, SO WE PRINT IN ITS COLOR

getResult(_, notLost, notWon, no). %THE GAME IS NOT OVER, KEEP PLAYING!

%player colors
playerColor(p1, red).
playerColor(p2, blue).



%ENDGAME
playerWon(Board, Coordinates, Player, Result):-
    nth1(1, Coordinates, Type),
    getNeighbours(Board, Type, Coordinates, NeighboursList), %the way we get neighbours depends on the type of piece
    oppositePlayer(Player, OppositePlayer), %get opposite player
    collectEnemyPieces(OppositePlayer, NeighboursList, [], EnemyList), %get enemies adjacent to the main piece
    areThereEnemies(Board, OppositePlayer, EnemyList, Result). % if there are enemies we verify each of them
    
areThereEnemies(_, _, [], notWon):- !. %no enemies around means it is not possible to win in this condition

areThereEnemies(Board, OppositePlayer, EnemyList, Result):-
    checkEnemyLost(Board, OppositePlayer, EnemyList, IntermediateResult),
    formulateResult(IntermediateResult, Result).

formulateResult(lost, won):- !. %if the enemy lost, it means the player won
formulateResult(_, notWon):- !. %if the enemy did not lose, then the player did not win


%check all the enemy pieces surrounding to check if the enemy lost, it is enough that one piece originates a loss
checkEnemyLost(_, _, [], notLost).

checkEnemyLost(Board, Player, [H|T], Result):-
    playerLost(Board, H, Player, [], IntermediateResult),
    didEnemyLose(Board, Player, T, IntermediateResult, Result),
    !.

didEnemyLose(_, _, _, lost, lost):- !.

didEnemyLose(Board, Player, T, _, Result):-
    checkEnemyLost(Board, Player, T, Result), % recursive call
    !.


%Player lost
playerLost(_, ['R'|_], _, _, notLost). % player chose a rectangle, it is impossible to lose this way

playerLost(Board, Coordinates, Player, VerifiedCells, Result):- %player chose a triangle or square
    checkCell(Board, Coordinates, Player, VerifiedCells, IntermediateResult),
    didPlayerLose(IntermediateResult, Result).

didPlayerLose(IntermediateResult, lost):-
    IntermediateResult \= notLost.

didPlayerLose(notLost, notLost).


%CHECK CELL
checkCell(Board, Coordinates, Player, VerifiedCells, Result):-
    append(VerifiedCells, [Coordinates], NewVerifiedCells), %add coordinates of the cell we are testing to the verified cell list
    nth1(1, Coordinates, Type), %type means Q or T
    getNeighbours(Board, Type, Coordinates, NeighboursList), %get the cells neighbours
    checkNeighbours(Player, NewVerifiedCells, NeighboursList, [], NeighboursToAnalyse, IntermediateResult), %get neighbours to analyse
    analyseNeighbours(IntermediateResult, Board, Player, NewVerifiedCells, NeighboursToAnalyse, Result).


% ANALYSE NEIGHBOURS
analyseNeighbours(notLost, _, _, _, _, notLost):- !.

analyseNeighbours(_, _, _, _, [], _) :- !.

analyseNeighbours(_, Board, Player, VerifiedCells, [H|T], Result):-
    checkCell(Board, H, Player, VerifiedCells, IntermediateResult),
    analyseNeighbours(IntermediateResult, Board, Player, VerifiedCells, T, Result),
    !.

%---------- NEIGHBOURING ----------%

% DEALING WITH A CELL'S NEIGHBOURS
getNeighbours(Board, 'Q', Coordinates, [CellUp, CellLeft, CellRight, CellDown]):-
    nth1(2, Coordinates, Row),
    nth1(3, Coordinates, Col),
    getCellUp(Board, Row, Col, CellUp),
    getCellLeft(Board, Row, Col, CellLeft),
    getCellRight(Board, Row, Col, CellRight),
    getCellDown(Board, Row, Col, CellDown).

% GET RECTANGLE NEIGHBOURS
getNeighbours(Board, 'R', Coordinates, Neighbours):-
    nth1(4, Coordinates, ID),
    getRectangleNeighbours(Board, ID, Neighbours).

%if the piece is a triangle, it is more complex to fetch its neighbours
getNeighbours(Board, 'T', Coordinates, NeighboursList):-
    nth1(2, Coordinates, Row),
    nth1(3, Coordinates, Col),
    nth1(4, Coordinates, N),
    nth1(5, Coordinates, Orientation),
    getTriangleNeighbours(Board, Row, Col, Orientation, N, NeighboursList).

getTriangleNeighbours(Board, Row, Col, up, 1, [CellUp, CellLeft, TriangleRight]):-
    getCellUp(Board, Row, Col, CellUp),
    getCellLeft(Board, Row, Col, CellLeft),
    getTriangleRight(Board, Row, Col, TriangleRight).

getTriangleNeighbours(Board, Row, Col, up, 2, [TriangleLeft, CellRight, CellDown]):-
    getTriangleLeft(Board, Row, Col, TriangleLeft),
    getCellRight(Board, Row, Col, CellRight),
    getCellDown(Board, Row, Col, CellDown).

getTriangleNeighbours(Board, Row, Col, dw, 1, [CellLeft, TriangleRight, CellDown]):-
    getCellLeft(Board, Row, Col, CellLeft),
    getTriangleRight(Board, Row, Col, TriangleRight),
    getCellDown(Board, Row, Col, CellDown).
    
getTriangleNeighbours(Board, Row, Col, dw, 2, [CellUp, TriangleLeft, CellRight]):-
    getCellUp(Board, Row, Col, CellUp),
    getTriangleLeft(Board, Row, Col, TriangleLeft),
    getCellRight(Board, Row, Col, CellRight).

% GET A DEFINED DIRECTION NEIGHBOUR
getCellUp(Board, Row, Col, Result):-
    RowUp is Row - 1,
    getCellat(Board, RowUp, Col, Cell),
    toCoordinates(Cell, RowUp, Col, toUp, Result).

getCellLeft(Board, Row, Col, Result):-
    ColLeft is Col - 1,
    getCellat(Board, Row, ColLeft, Cell),
    toCoordinates(Cell, Row, ColLeft, toLeft, Result).

getCellRight(Board, Row, Col, Result):-
    ColRight is Col + 1,
    getCellat(Board, Row, ColRight, Cell),
    toCoordinates(Cell, Row, ColRight, toRight, Result).

getCellDown(Board, Row, Col, Result):-
    RowDown is Row + 1,
    getCellat(Board, RowDown, Col, Cell),
    toCoordinates(Cell, RowDown, Col, toDown, Result).


%GET A TRIANGLE'S TRIANGLE COUNTERPART
getTriangleLeft(Board, Row, Col, TriangleLeft):-
    getCellat(Board, Row, Col, Cell),
    toCoordinates(Cell, Row, Col, toRight, TriangleLeft).

getTriangleRight(Board, Row, Col, TriangleRight):-
    getCellat(Board, Row, Col, Cell),
    toCoordinates(Cell, Row, Col, toLeft, TriangleRight).


%GET RECTANGLES'S NEIGHBOURS BASED ON IT ID
getRectangleNeighbours(Board, 1, [Cell1, Cell2, Cell3, Cell4]):-
    getCellDown(Board, 1, 2, Cell1),
    getCellDown(Board, 1, 3, Cell2),
    getCellDown(Board, 1, 4, Cell3),
    getCellDown(Board, 1, 5, Cell4).

getRectangleNeighbours(Board, 2, [Cell1, Cell2, Cell3, Cell4]):-
    getCellDown(Board, 1, 6, Cell1),
    getCellDown(Board, 1, 7, Cell2),
    getCellDown(Board, 1, 8, Cell3),
    getCellDown(Board, 1, 9, Cell4).

getRectangleNeighbours(Board, 3, [Cell1, Cell2, Cell3, Cell4]):-
    getCellLeft(Board, 2, 10, Cell1),
    getCellLeft(Board, 3, 10, Cell2),
    getCellLeft(Board, 4, 10, Cell3),
    getCellLeft(Board, 5, 10, Cell4).

getRectangleNeighbours(Board, 4, [Cell1, Cell2, Cell3, Cell4]):-
    getCellLeft(Board, 6, 10, Cell1),
    getCellLeft(Board, 7, 10, Cell2),
    getCellLeft(Board, 8, 10, Cell3),
    getCellLeft(Board, 9, 10, Cell4).

getRectangleNeighbours(Board, 5, [Cell1, Cell2, Cell3, Cell4]):-
    getCellUp(Board, 10, 6, Cell1),
    getCellUp(Board, 10, 7, Cell2),
    getCellUp(Board, 10, 8, Cell3),
    getCellUp(Board, 10, 9, Cell4).

getRectangleNeighbours(Board, 6, [Cell1, Cell2, Cell3, Cell4]):-
    getCellUp(Board, 10, 2, Cell1),
    getCellUp(Board, 10, 3, Cell2),
    getCellUp(Board, 10, 4, Cell3),
    getCellUp(Board, 10, 5, Cell4).

getRectangleNeighbours(Board, 7, [Cell1, Cell2, Cell3, Cell4]):-
    getCellRight(Board, 6, 1, Cell1),
    getCellRight(Board, 7, 1, Cell2),
    getCellRight(Board, 8, 1, Cell3),
    getCellRight(Board, 9, 1, Cell4).

getRectangleNeighbours(Board, 8, [Cell1, Cell2, Cell3, Cell4]):-
    getCellRight(Board, 2, 1, Cell1),
    getCellRight(Board, 3, 1, Cell2),
    getCellRight(Board, 4, 1, Cell3),
    getCellRight(Board, 5, 1, Cell4).


%DISCOVER ENEMY PLAYER NEIGHBOUR PIECES
collectEnemyPieces(_, [], AuxiliaryList, AuxiliaryList):- !. %no more neighbour pieces to test, we finish

collectEnemyPieces(EnemyPlayer, [H|T], AuxiliaryList, EnemyList):-
    getCellPlayer(H, EnemyPlayer), %confirm if player is enemy
    append(AuxiliaryList, [H], NewAuxiliaryList),% add it to enemy list
    collectEnemyPieces(EnemyPlayer, T, NewAuxiliaryList, EnemyList), %recursive call
    !.

collectEnemyPieces(EnemyPlayer, [_|T], AuxiliaryList, EnemyList):-
    collectEnemyPieces(EnemyPlayer, T, AuxiliaryList, EnemyList), %not an enemy piece, recursive call only
    !.



%CHECK NEIHBOURS ON 3 POSSIBLE OUTCOMES EACH: SAME COLOR, OPPOSITE COLOR OR NONE, ON NONE, WE IMMEDIATELY RETURN FALSE
checkNeighbours(_, _, [], [], _, surrounded):- !.  %no new neighbours  around nor unoccupied cells

checkNeighbours(_, _, [], AuxiliaryList, AuxiliaryList, continueAnalysing):- !.%list of new neighbours of same color is returned

checkNeighbours(Player, _, [H|_], _, _, notLost):- %the player is automaticly safe from losing if
    (getCellPlayer(H, nill)  % neighbour cell is not owned by any player
    ; (nth1(1, H, 'R') , getCellPlayer(H, Player)) % OR neighbour cell is a rectangle of the same color
    ),
    !. 

checkNeighbours(Player, VerifiedCells, [H|T], AuxiliaryList, NeighboursToAnalyse, Result):-
    getCellPlayer(H, Player), %neighbour cell of same color
    searchVisitedCells(VerifiedCells, H, IsVisited),
    IsVisited == no, % it is not visited yet (not new neighbour)
    append(AuxiliaryList, [H], NewAuxiliaryList), % add to new neighbours list
    checkNeighbours(Player, VerifiedCells, T, NewAuxiliaryList, NeighboursToAnalyse, Result), %recursive call
    !.
    
checkNeighbours(Player, VerifiedCells, [_|T], AuxiliaryList, NeighboursToAnalyse, Result):- %all cases above fail
    checkNeighbours(Player, VerifiedCells, T, AuxiliaryList, NeighboursToAnalyse, Result), %recursive call
    !.

%--------- NEIGHBOURING ---------%


%TRANSFORM CELLS INTO COORDINATES
toCoordinates(['R'|T], Row, Col, _, ['R', Row, Col, Player]):-
    nth1(2,T, Player).

toCoordinates(['Q'|T], Row, Col, _, ['Q', Row, Col, Player]):-
    nth1(1,T, Player).

toCoordinates(['T'|T], Row, Col, To, ['T', Row, Col, N, Orientation, Player]):-
    nth1(1,T, Orientation),
    whichSideofTriangle(Orientation, N, To),
    X is N + 1,
    nth1(X, T, Player).


%GET PLAYERS
getCellPlayer(['Q'|T], Player):-
    nth1(3, T, Player).

getCellPlayer(['T'|T], Player):-
    nth1(5, T, Player).

getOppositePlayer(Coordinates, Player):-
    getCellPlayer(Coordinates, AuxPlayer),
    oppositePlayer(AuxPlayer, Player).

oppositePlayer(p1, p2).
oppositePlayer(p2, p1).



%GET TRIANGLE SIDE
whichSideofTriangle(up, 2, toUp).

whichSideofTriangle(dw, 1, toUp).

whichSideofTriangle(up, 1, toDown).

whichSideofTriangle(dw, 2, toDown).

whichSideofTriangle(_, 2, toLeft).

whichSideofTriangle(_, 1, toRight).



%GET CELL AT A DETERMINED ROW AND COLUMN
getCellat(Board, Row, Col, Cell):-
    nth1(Row, Board, Line),
    nth1(Col, Line, Cell).


%--------- SEARCH VISITED CELLS --------%

searchVisitedCells([], _, no):- !.

searchVisitedCells([H|_], Info, yes):-
    nth1(1, H, Type),
    nth1(1, Info, Type2),
    Type == Type2,
    Type == 'T',
    nth1(2, H, R),
    nth1(2, Info, R1),
    R == R1,
    nth1(3, H, R2),
    nth1(3, Info, R3),
    R2 == R3,
    nth1(4, H, R4),
    nth1(4, Info, R5),
    R4 == R5,
    !.

searchVisitedCells([H|_], Info, yes):-
    nth1(1, H, Type),
    nth1(1, Info, Type2),
    Type == Type2,
    Type == 'Q',
    nth1(2, H, R),
    nth1(2, Info, R1),
    R == R1,
    nth1(3, H, R2),
    nth1(3, Info, R3),
    R2 == R3,
    !.

searchVisitedCells([_|T], Info, Result):-
    searchVisitedCells(T, Info, Result).
