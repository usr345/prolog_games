%-*- mode: prolog-*-
state([location(яблоко, стол), location(стол, столовая)]).
takable(яблоко).
isOpen(Object, State) :-
    append([_, [open(Object)], _], State).

can_take(What, state{here: H, locations: Loc, items: _}) :-
    takable(What),
    append([_, [location(What, H)], _], Loc).

can_take(What, state{here: H, locations: Loc, items: St}) :-
    takable(What),
    append([_, [location(Cont, H)], _], Loc),
    isOpen(Cont, St),
    can_take(What, state{here: Cont, locations: Loc, items: St}).
