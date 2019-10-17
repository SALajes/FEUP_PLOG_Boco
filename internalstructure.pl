%('R',x,i) -> R is a rectangle; x is the id (a to h); i is the owner (nill, pup or pdw)
%('Q', i) -> Q is a square; l is the row (up to 8); c the column (1 to 8); i is the owner (nill, p1 or pdw)
%('T', o, i, j) -> T is a triangle; o is the orientation ('/' or '\\'); i the ownership of the first triangle; j the ownership of the second

bocoStructure([
    [['R',8,nill], ['R',1,nill],['R',1,nill],['R',1,nill],['R',1,nill], ['R',2,nill],['R',2,nill],['R',2,nill],['R',2,nill],['R',2,nill]],
    [['R',8,nill], ['Q',nill], ['T',up,nill,nill], ['Q',nill], ['T',up,nill,nill], ['Q',nill], ['T',up,nill,nill], ['Q',nill], ['T',up,nill,nill], ['R',3,nill]],
    [['R',8,nill], ['T',dw,nill,nill], ['Q',nill], ['T',dw,nill,nill], ['Q',nill], ['T',dw,nill,nill], ['Q',nill], ['T',dw,nill,nill], ['Q',nill], ['R',3,nill]],
    [['R',8,nill], ['Q',nill], ['T',up,nill,nill], ['Q',nill], ['T',up,nill,nill], ['Q',nill], ['T',up,nill,nill], ['Q',nill], ['T',up,nill,nill], ['R',3,nill]],
    [['R',8,nill], ['T',dw,nill,nill], ['Q',nill], ['T',dw,nill,nill], ['Q',nill], ['T',dw,nill,nill], ['Q',nill], ['T',dw,nill,nill], ['Q',nill], ['R',3,nill]],
    [['R',7,nill], ['Q',nill], ['T',up,nill,nill], ['Q',nill], ['T',up,nill,nill], ['Q',nill], ['T',up,nill,nill], ['Q',nill], ['T',up,nill,nill], ['R',4,nill]],
    [['R',7,nill], ['T',dw,nill,nill], ['Q',nill], ['T',dw,nill,nill], ['Q',nill], ['T',dw,nill,nill], ['Q',nill], ['T',dw,nill,nill], ['Q',nill], ['R',4,nill]],
    [['R',7,nill], ['Q',nill], ['T',up,nill,nill], ['Q',nill], ['T',up,nill,nill], ['Q',nill], ['T',up,nill,nill], ['Q',nill], ['T',up,nill,nill], ['R',4,nill]],
    [['R',7,nill], ['T',dw,nill,nill], ['Q',nill], ['T',dw,nill,nill], ['Q',nill], ['T',dw,nill,nill], ['Q',nill], ['T',dw,nill,nill], ['Q',nill], ['R',4,nill]],
    [['R',6,nill],['R',6,nill],['R',6,nill],['R',6,nill],['R',6,nill], ['R',5,nill],['R',5,nill],['R',5,nill],['R',5,nill], ['R',4,nill]]
]).