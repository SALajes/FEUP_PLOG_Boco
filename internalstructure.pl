%('Rx',i) -> R is a rectangle; x is the id (a to h); i is the owner (nill, pup or pdw)
%('Q', i) -> Q is a square; l is the row (up to 8); c the column (1 to 8); i is the owner (nill, p1 or pdw)
%('T', o, i, j) -> T is a triangle; o is the orientation ('/' or '\\'); i the ownership of the first triangle; j the ownership of the second

bocoStructure([
    [['R8',nill], ['R1',nill],['R1',nill],['R1',nill],['R1',nill], ['R2',nill],['R2',nill],['R2',nill],['R2',nill],['R2',nill]],
    [['R8',nill], ['Q',nill], ['T',up,nill,nill], ['Q',nill], ['T',up,nill,nill], ['Q',nill], ['T',up,nill,nill], ['Q',nill], ['T',up,nill,nill], ['R3',nill]],
    [['R8',nill], ['T',dw,nill,nill], ['Q',nill], ['T',dw,nill,nill], ['Q',nill], ['T',dw,nill,nill], ['Q',nill], ['T',dw,nill,nill], ['Q',nill], ['R3',nill]],
    [['R8',nill], ['Q',nill], ['T',up,nill,nill], ['Q',nill], ['T',up,nill,nill], ['Q',nill], ['T',up,nill,nill], ['Q',nill], ['T',up,nill,nill], ['R3',nill]],
    [['R8',nill], ['T',dw,nill,nill], ['Q',nill], ['T',dw,nill,nill], ['Q',nill], ['T',dw,nill,nill], ['Q',nill], ['T',dw,nill,nill], ['Q',nill], ['R3',nill]],
    [['R7',nill], ['Q',nill], ['T',up,nill,nill], ['Q',nill], ['T',up,nill,nill], ['Q',nill], ['T',up,nill,nill], ['Q',nill], ['T',up,nill,nill], ['R4',nill]],
    [['R7',nill], ['T',dw,nill,nill], ['Q',nill], ['T',dw,nill,nill], ['Q',nill], ['T',dw,nill,nill], ['Q',nill], ['T',dw,nill,nill], ['Q',nill], ['R4',nill]],
    [['R7',nill], ['Q',nill], ['T',up,nill,nill], ['Q',nill], ['T',up,nill,nill], ['Q',nill], ['T',up,nill,nill], ['Q',nill], ['T',up,nill,nill], ['R4',nill]],
    [['R7',nill], ['T',dw,nill,nill], ['Q',nill], ['T',dw,nill,nill], ['Q',nill], ['T',dw,nill,nill], ['Q',nill], ['T',dw,nill,nill], ['Q',nill], ['R4',nill]],
    [['R6',nill],['R6',nill],['R6',nill],['R6',nill],['R6',nill], ['R5',nill],['R5',nill],['R5',nill],['R5',nill], ['R4',nill]]
]).