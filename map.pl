:- include('init.pl').

dynamic :- (lebarPeta/1).
dynamic :- (tinggiPeta/1).
dynamic :- (posisiGym/2).
dynamic :- (rintangan/2).

init_map :-
    random(10,50,X),
    random(10,50,Y),
    random(1,X,XGym),
    random(1,Y,YGym),
    asserta(lebarPeta(X)),
    asserta(tinggiPeta(Y)),
    asserta(posisiXGym(XGym,YGym)),
    asserta(player_position(1,1)),
    generateRintangan,
    !.
    
isTopBorder(_,Y) :- 
    Y=:=0,!.

isLeftBorder(X,_) :-
    X=:=0,!.

isRightBorder(X,_) :-
    lebarPeta(A),
    XRight is A+1,
    X =:= XRight,
    !.

isBottomBorder(_,Y) :-
    tinggiPeta(A),
    YRight is A+1,
    Y =:= YRight,
    !.

isGym(X,Y) :-
    posisiGym(A,B),
    X =:= A,
    Y =:= B,
    !.

isRintangan(X,Y) :-
    rintangan(A,B),
    X =:= A,
    Y =:= B,
    !.

% PRINT KEBERJALANAN PROGRAM BELUM YAAAA
printMap(X,Y) :-
    player_position(X,Y), !, write('P').
printMap(X,Y) :-
    isGym(X,Y), !, write('G').
printMap(X,Y) :-
    isRightBorder(X,Y), !, write('X').
printMap(X,Y) :-
    isLeftBorder(X,Y), !, write('X').
printMap(X,Y) :-
    isTopBorder(X,Y), !, write('X').
printMap(X,Y) :-
    isBottomBorder(X,Y), !, write('X').
printMap(X,Y) :-
    rintangan(X,Y), !, write('X').
printMap(_,_) :-
	write('-').

generateRintangan :-
    lebarPeta(X),
    tinggiPeta(Y),
    XMin is 2,
	XMax is X,
	YMin is 2,
    YMax is Y,
    Sum is X*Y/10,
        
    forall(between(1,Sum,S), (
        random(XMin,XMax, A),
        random(YMin,YMax, B),
        rintangan(A,B)
        )),
    !.
    
