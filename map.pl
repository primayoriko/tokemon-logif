:- dynamic(lebarPeta/1).
:- dynamic(tinggiPeta/1).
:- dynamic(posisiGym/2).
:- dynamic(rintangan/2).
:- dynamic(ctrheal/1).

:- include('player.pl').


init_map :-
    random(10,50,X),
    random(10,50,Y),
    random(1,X,XGym),
    random(1,Y,YGym),
    asserta(ctrheal(0)),
    asserta(lebarPeta(X)),
    asserta(tinggiPeta(Y)),
    asserta(posisiGym(XGym,YGym)),
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
/* BUAT DEBUGGGGGG DOANGGGGG */

goToGym :-
    posisiGym(A,B),
    X2 is A,
    Y2 is B,
    retract(player_position(X,Y)),
	asserta(player_position(X2,Y2)), !.

setHealthTo0 :- 
    Y is 0,
    retract(inventory(Tokemon,Health,N,S,NS,T,I)),
    asserta(inventory(Tokemon,Y,N,S,NS,T,I)). 

setHealthToFull :- 
    inventory(Tokemon,Health,N,S,NS,T,I),
    tokemon(Tokemon,Health1,_,_,_,_,_),
    Y is Health1,
    retract(inventory(Tokemon,Health,N,S,NS,T,I)),
    asserta(inventory(Tokemon,Y,N,S,NS,T,I)). 

heal :-
    /* Pemain belum pernah melakukan heal dan berada di posisi Gym*/
    ctrheal(0),
    player_position(X,Y),
    posisiGym(A,B),
    X is A,
    Y is B, 
    setHealthToFull,
    write('Tokemon anda sudah disembuhkan!'),
    nl,
    retract(ctrheal(Counter)),
    asserta(ctrheal(1)) ,!. 
    
heal :-
    /* Pemain sudah pernah melakukan heal */
    ctrheal(1), ! ,write('udah heal'),
    write('Tokemon gagal disembuhkan. Anda sudah menggunakan fitur ini.'),
    nl. 


heal :-
    /* Pemain belum pernah melakukan heal dan TIDAK berada di posisi Gym*/
    ctrheal(0),
    player_position(X,Y),
    posisiGym(A,B),
    (Y =\= B; X  =\= A),
    write('Anda tidak bisa menggunakan fitur ini karena tidak berada pada posisi Gym.'),
    nl,
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
    random(2,X,A),
    random(2,Y,B),
    asserta(rintangan(A,B)),!.

printTheWholeMap :-
    lebarPeta(X),
    tinggiPeta(Y),
    XXX is X +1,
    YYY is Y +1,
    forall(between(0,YYY,YY),
        (forall(between(0,XXX,XX),
            printMap(XX,YY)
        ),nl)
    ),!.


posi :-
    player_position(X,Y),
    write(X), nl,
    write(Y), ! .

n :-
    player_position(X,Y),
    Y > 1,
	Y2 is Y-1,
    X2 is X,
    write([X2,Y2]),nl,
    retract(player_position(X,Y)),
	asserta(player_position(X2,Y2)),roll, !.

n :-
    player_position(_,Y),
    Y < 2,
    write('nabrak bray'),nl,
    !.

s :-
    player_position(X,Y),
    tinggiPeta(YY),
	Y < YY,
	Y2 is Y+1,
    X2 is X,
	write([X2,Y2]),nl,
    retract(player_position(X,Y)),
	asserta(player_position(X2,Y2)),
    roll, !.

s :-
    player_position(_,Y),
    tinggiPeta(YY),
    YYY is YY-1,
    Y > YYY,
    write('nabrak bray'),nl,
    !.

e :-
    player_position(X,_),
    lebarPeta(XX),
    XXX is XX-1,
    X > XXX,
    write('nabrak bray'),nl,
    !.

e :-
    player_position(X,Y),
    lebarPeta(XX),
	X < XX,
    Y2 is Y,
	X2 is X+1,
	write([X2,Y2]),nl,
    retract(player_position(X,Y)),
	asserta(player_position(X2,Y2)),
    roll, !.

w :-
    player_position(X,_),
    X < 2,
    write('nabrak bray'),nl,
    !.

w :-
    player_position(X,Y),
	X > 1,
	Y2 is Y,
    X2 is X-1,
	write([X2,Y2]),nl,
    retract(player_position(X,Y)),
	asserta(player_position(X2,Y2)), 
    roll.

roll :-
    posisiGym(A,B),
    player_position(X,Y),
    X =:= A, Y =:= B,
    write('welcome to the gym!'),nl, !.

roll :-
    posisiGym(A,_),
    player_position(X,_),
    A =\= X,
    random(1,100,X),
    encounterroll(X),!.

roll :-
    posisiGym(_,B),
    player_position(_,Y),
    B =\= Y,
    random(1,100,X),
    encounterroll(X),!.


encounterroll(X) :-
    X > 90 -> (write('anda bertemu pokemon legendary'), !);
    (X < 90, X > 60) -> (write('anda bertemu pokemon biasa'), !);
    write('moved'),
    !.



