entity(X) :- part_of(X,_).
entity(X) :- part_of(_,X).
notAncestor(E) :- seed(S), entity(E), not part_of(S,E).
common(E) :- entity(E), not notAncestor(E).
equiv(X,Y) :- part_of(X,Y), part_of(Y,X).
noLeastCommon(E) :- common(E), part_of(C,E), common(C), not equiv(C,E).
leastCommon(X) :- common(X), not noLeastCommon(X).