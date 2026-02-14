entity(X) :- is_a(X,_).
entity(X) :- is_a(_,X).
notAncestor(E) :- seed(S), entity(E), not is_a(S,E).
common(E) :- entity(E), not notAncestor(E).
equiv(X,Y) :- is_a(X,Y), is_a(Y,X).
noLeastCommon(E) :- common(E), is_a(C,E), common(C), not equiv(C,E).
leastCommon(X) :- common(X), not noLeastCommon(X).