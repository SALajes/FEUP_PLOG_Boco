%('R',x,i) -> R is a rectangle; x is the id (1 to 8); i is the owner (nill, pup or pdw)
%('Q', i) -> Q is a square; l is the row (up to 8); c the column (1 to 8); i is the owner (nill, p1 or p2)
%('T', o, i, j) -> T is a triangle; o is the orientation ('/' or '\\'); i the ownership of the first triangle; j the ownership of the second

bocoStructure([
    [['R',8,nill], ['R',1,nill],['R',1,nill],['R',1,nill],['R',1,nill], ['R',2,nill],['R',2,nill],['R',2,nill],['R',2,nill],['R',2,nill]],
    [['R',8,nill], ['Q',nill], ['T',dw,nill,nill], ['Q',nill], ['T',dw,nill,nill], ['Q',nill], ['T',dw,nill,nill], ['Q',nill], ['T',dw,nill,nill], ['R',3,nill]],
    [['R',8,nill], ['T',up,nill,nill], ['Q',nill], ['T',up,nill,nill], ['Q',nill], ['T',up,nill,nill], ['Q',nill], ['T',up,nill,nill], ['Q',nill], ['R',3,nill]],
    [['R',8,nill], ['Q',nill], ['T',dw,nill,nill], ['Q',nill], ['T',dw,nill,nill], ['Q',nill], ['T',dw,nill,nill], ['Q',nill], ['T',dw,nill,nill], ['R',3,nill]],
    [['R',8,nill], ['T',up,nill,nill], ['Q',nill], ['T',up,nill,nill], ['Q',nill], ['T',up,nill,nill], ['Q',nill], ['T',up,nill,nill], ['Q',nill], ['R',3,nill]],
    [['R',7,nill], ['Q',nill], ['T',dw,nill,nill], ['Q',nill], ['T',dw,nill,nill], ['Q',nill], ['T',dw,nill,nill], ['Q',nill], ['T',dw,nill,nill], ['R',4,nill]],
    [['R',7,nill], ['T',up,nill,nill], ['Q',nill], ['T',up,nill,nill], ['Q',nill], ['T',up,nill,nill], ['Q',nill], ['T',up,nill,nill], ['Q',nill], ['R',4,nill]],
    [['R',7,nill], ['Q',nill], ['T',dw,nill,nill], ['Q',nill], ['T',dw,nill,nill], ['Q',nill], ['T',dw,nill,nill], ['Q',nill], ['T',dw,nill,nill], ['R',4,nill]],
    [['R',7,nill], ['T',up,nill,nill], ['Q',nill], ['T',up,nill,nill], ['Q',nill], ['T',up,nill,nill], ['Q',nill], ['T',up,nill,nill], ['Q',nill], ['R',4,nill]],
    [['R',6,nill],['R',6,nill],['R',6,nill],['R',6,nill],['R',6,nill], ['R',5,nill],['R',5,nill],['R',5,nill],['R',5,nill], ['R',4,nill]]
]).

initialBoard([
    [['R',8,nill], ['R',1,nill],['R',1,nill],['R',1,nill],['R',1,nill], ['R',2,nill],['R',2,nill],['R',2,nill],['R',2,nill],['R',2,nill]],
    [['R',8,nill], ['Q',1,nill], ['T',1,dw,nill,nill], ['Q',2,nill], ['T',2,dw,nill,nill], ['Q',3,nill], ['T',3,dw,nill,nill], ['Q',4,nill], ['T',4,dw,nill,nill], ['R',3,nill]],
    [['R',8,nill], ['T',5,up,nill,nill], ['Q',5,nill], ['T',6,up,nill,nill], ['Q',6,nill], ['T',7,up,nill,nill], ['Q',7,nill], ['T',8,up,nill,nill], ['Q',8,nill], ['R',3,nill]],
    [['R',8,nill], ['Q',9,nill], ['T',9,dw,nill,nill], ['Q',10,nill], ['T',10,dw,nill,nill], ['Q',11,nill], ['T',11,dw,nill,nill], ['Q',12,nill], ['T',12,dw,nill,nill], ['R',3,nill]],
    [['R',8,nill], ['T',13,up,nill,nill], ['Q',13,nill], ['T',14,up,nill,nill], ['Q',14,nill], ['T',15,up,nill,nill], ['Q',15,nill], ['T',16,up,nill,nill], ['Q',16,nill], ['R',3,nill]],
    [['R',7,nill], ['Q',17,nill], ['T',17,dw,nill,nill], ['Q',18,nill], ['T',18,dw,nill,nill], ['Q',19,nill], ['T',19,dw,nill,nill], ['Q',20,nill], ['T',20,dw,nill,nill], ['R',4,nill]],
    [['R',7,nill], ['T',21,up,nill,nill], ['Q',21,nill], ['T',22,up,nill,nill], ['Q',22,nill], ['T',23,up,nill,nill], ['Q',23,nill], ['T',24,up,nill,nill], ['Q',24,nill], ['R',4,nill]],
    [['R',7,nill], ['Q',25,nill], ['T',25,dw,nill,nill], ['Q',26,nill], ['T',26,dw,nill,nill], ['Q',27,nill], ['T',27,dw,nill,nill], ['Q',28,nill], ['T',28,dw,nill,nill], ['R',4,nill]],
    [['R',7,nill], ['T',29,up,nill,nill], ['Q',29,nill], ['T',30,up,nill,nill], ['Q',30,nill], ['T',31,up,nill,nill], ['Q',31,nill], ['T',32,up,nill,nill], ['Q',32,nill], ['R',4,nill]],
    [['R',6,nill],['R',6,nill],['R',6,nill],['R',6,nill],['R',6,nill], ['R',5,nill],['R',5,nill],['R',5,nill],['R',5,nill], ['R',4,nill]]
]).

middleBoard([
    [['R',8,nill], ['R',1,nill],['R',1,nill],['R',1,nill],['R',1,nill], ['R',2,nill],['R',2,nill],['R',2,nill],['R',2,nill],['R',2,nill]],
    [['R',8,nill], ['Q',1,nill], ['T',1,dw,nill,nill], ['Q',2,nill], ['T',2,dw,nill,nill], ['Q',3,nill], ['T',3,dw,nill,nill], ['Q',4,nill], ['T',4,dw,nill,nill], ['R',3,nill]],
    [['R',8,nill], ['T',5,up,nill,nill], ['Q',5,nill], ['T',6,up,nill,nill], ['Q',6,nill], ['T',7,up,nill,nill], ['Q',7,nill], ['T',8,up,nill,nill], ['Q',8,nill], ['R',3,nill]],
    [['R',8,nill], ['Q',9,nill], ['T',9,dw,nill,nill], ['Q',10,p1], ['T',10,dw,p2,p1], ['Q',11,nill], ['T',11,dw,nill,nill], ['Q',12,nill], ['T',12,dw,nill,nill], ['R',3,nill]],
    [['R',8,nill], ['T',13,up,nill,nill], ['Q',13,nill], ['T',14,up,p2,p1], ['Q',14,nill], ['T',15,up,nill,nill], ['Q',15,nill], ['T',16,up,nill,nill], ['Q',16,nill], ['R',3,nill]],
    [['R',7,nill], ['Q',17,nill], ['T',17,dw,nill,nill], ['Q',18,p2], ['T',18,dw,p1,p2], ['Q',19,nill], ['T',19,dw,nill,nill], ['Q',20,nill], ['T',20,dw,nill,nill], ['R',4,nill]],
    [['R',7,nill], ['T',21,up,nill,nill], ['Q',21,nill], ['T',22,up,nill,nill], ['Q',22,p1], ['T',23,up,nill,nill], ['Q',23,nill], ['T',24,up,nill,nill], ['Q',24,nill], ['R',4,nill]],
    [['R',7,nill], ['Q',25,nill], ['T',25,dw,nill,nill], ['Q',26,nill], ['T',26,dw,nill,nill], ['Q',27,nill], ['T',27,dw,nill,nill], ['Q',28,nill], ['T',28,dw,nill,nill], ['R',4,nill]],
    [['R',7,nill], ['T',29,up,nill,nill], ['Q',29,nill], ['T',30,up,nill,nill], ['Q',30,nill], ['T',31,up,nill,nill], ['Q',31,nill], ['T',32,up,nill,nill], ['Q',32,nill], ['R',4,nill]],
    [['R',6,nill],['R',6,nill],['R',6,nill],['R',6,nill],['R',6,nill], ['R',5,nill],['R',5,nill],['R',5,nill],['R',5,nill], ['R',4,nill]]
]).

endBoard([
    [['R',8,nill], ['R',1,nill],['R',1,nill],['R',1,nill],['R',1,nill], ['R',2,nill],['R',2,nill],['R',2,nill],['R',2,nill],['R',2,nill]],
    [['R',8,nill], ['Q',1,nill], ['T',1,dw,nill,nill], ['Q',2,nill], ['T',2,dw,nill,nill], ['Q',3,nill], ['T',3,dw,nill,nill], ['Q',4,nill], ['T',4,dw,nill,nill], ['R',3,nill]],
    [['R',8,nill], ['T',5,up,nill,nill], ['Q',5,nill], ['T',6,up,nill,p1], ['Q',6,p2], ['T',7,up,p1,p2], ['Q',7,p1], ['T',8,up,nill,nill], ['Q',8,nill], ['R',3,nill]],
    [['R',8,nill], ['Q',9,nill], ['T',9,dw,nill,p1], ['Q',10,p1], ['T',10,dw,p2,p1], ['Q',11,nill], ['T',11,dw,p1,p2], ['Q',12,nill], ['T',12,dw,nill,nill], ['R',3,nill]],
    [['R',8,nill], ['T',13,up,nill,nill], ['Q',13,nill], ['T',14,up,p2,p1], ['Q',14,nill], ['T',15,up,nill,nill], ['Q',15,p2], ['T',16,up,p1,p2], ['Q',16,nill], ['R',3,nill]],
    [['R',7,nill], ['Q',17,nill], ['T',17,dw,nill,nill], ['Q',18,p2], ['T',18,dw,p1,p2], ['Q',19,nill], ['T',19,dw,nill,p2], ['Q',20,p1], ['T',20,dw,p2,nill], ['R',4,nill]],
    [['R',7,nill], ['T',21,up,nill,nill], ['Q',21,nill], ['T',22,up,nill,nill], ['Q',22,p1], ['T',23,up,nill,nill], ['Q',23,nill], ['T',24,up,p2,nill], ['Q',24,nill], ['R',4,nill]],
    [['R',7,nill], ['Q',25,nill], ['T',25,dw,nill,nill], ['Q',26,nill], ['T',26,dw,nill,nill], ['Q',27,nill], ['T',27,dw,nill,nill], ['Q',28,nill], ['T',28,dw,nill,nill], ['R',4,nill]],
    [['R',7,nill], ['T',29,up,nill,nill], ['Q',29,nill], ['T',30,up,nill,nill], ['Q',30,nill], ['T',31,up,nill,nill], ['Q',31,nill], ['T',32,up,nill,nill], ['Q',32,nill], ['R',4,nill]],
    [['R',6,nill],['R',6,nill],['R',6,nill],['R',6,nill],['R',6,nill], ['R',5,nill],['R',5,nill],['R',5,nill],['R',5,nill], ['R',4,nill]]
]).