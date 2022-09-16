%-*- mode: prolog-*-
use_module(library(st/st_render)).
:- dynamic here/1.
:- dynamic have/1.
:- dynamic location/2.
:- dynamic door/3.

%% step(operation, old_state, new_state).
step(move(Where), state{here:H, locations:Loc, items: St}, state{here: Where, locations: Loc, items: St}) :-
    canmove(H, Where).

step(take(What)state{here: H, locations:Loc, items: St}, state{here: H, locations: Loc, items: St}) :-
    can_take(What).
step(drop(What), old_state, new_state).

room('кабинет').
room('зал').
room('столовая').
room('кухня').
room('погреб').

location('стол', 'кабинет').
location('яблоко', 'кухня').
location(flashlight, 'стол').
location('стиральная машина', 'погреб').
location(nani, 'стиральная машина').
location(broccoli, 'кухня').
location(crackers, 'кухня').
location('компьютер', 'кабинет').

door('кабинет', 'зал', closed).
door('зал', 'столовая', closed).
door('столовая', 'кухня', closed).
door('кабинет', 'кухня', closed).
door('кухня', 'погреб', closed).

connect(X, Y, Status) :- door(X, Y, Status).
connect(X, Y, Status) :- door(Y, X, Status).

edible('яблоко').
edible(crackers).
% противный
tastes_yucky(broccoli).

turned_off(flashlight).
here('кухня').

list_things(Place) :-
    location(X, Place),
    tab(2),
    write(X),
    nl,
    fail.

list_things(_).

print_door_status(X, Place) :-
    connect(X, Place, closed),
    write('(X)').

print_door_status(X, Place) :-
    connect(X, Place, opened).

list_connections(Place) :-
    connect(Place, X, _),
    tab(2),
    write(X),
    write(' '),
    print_door_status(X, Place),
    nl,
    fail.

list_connections(_).

look :-
    here(Place),
    write('Вы находитесь в: '), write(Place), nl,
    write('Вы видите: '), nl,
    list_things(Place),
    write('Вы можете пойти в:'), nl,
    list_connections(Place).

goto(Place) :-
    can_go(Place),
    move(Place),
    look.

can_go(Place) :-
    here(X),
    connect(X, Place, opened).

can_go(Place) :-
    here(X),
    connect(X, Place, closed),
    write('Вы можете попасть в '),
    write(Place), write(','), nl,
    write('но нужно открыть дверь.'),
    !, fail.

can_go(Place) :-
    write('Вы не можете попасть в '),
    write(Place),
    write(' отсюда'), nl,
    fail.

move(Place) :-
    retract(here(_)),
    asserta(here(Place)).

take(X) :-
    can_take(X),
    take_object(X).

can_take(Thing) :-
    here(Place),
    location(Thing, Place).

can_take(Thing) :-
    write('There is no '), write(Thing),
    write(' here.'), nl,
    fail.

take_object(X) :-
    retract(location(X, _)),
    asserta(have(X)),
    write('taken'), nl.

put(X) :-
    have(X),
    retract(have(X)),
    here(Place),
    asserta(location(X, Place)),
    write('put'), nl.

inventory :-
    write('У вас есть:'), nl,
    tab(2),
    have(X),
    write(X),
    nl,
    fail.

open(Place) :-
    here(X),
    door(Place, X, closed),
    retract(door(Place, X, closed)),
    asserta(door(Place, X, opened)).

open(Place) :-
    here(X),
    door(X, Place, closed),
    retract(door(X, Place, closed)),
    asserta(door(X, Place, opened)).

open(Place) :-
    here(X),
    connect(X, Place, opened),
    writeln('Дверь уже открыта!').

close_door(Place) :-
    here(X),
    door(Place, X, opened),
    retract(door(Place, X, opened)),
    asserta(door(Place, X, closed)).

close_door(Place) :-
    here(X),
    door(X, Place, opened),
    retract(door(X, Place, opened)),
    asserta(door(X, Place, closed)).

close_door(Place) :-
    here(X),
    connect(Place, X, closed),
    writeln('Дверь уже закрыта!').
