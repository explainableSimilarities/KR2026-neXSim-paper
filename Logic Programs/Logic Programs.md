## Logic Programs

In our system, we use logic programs to encode the rules for inferring the least common neighbors for `is_a` and `part_of` relations. These logic programs are essential for our system to compute the `Kernel Explanations`.


```
entity(X) :- is_a(X,_).
entity(X) :- is_a(_,X).
notAncestor(E) :- seed(S), entity(E), not is_a(S,E).
common(E) :- entity(E), not notAncestor(E).
equiv(X,Y) :- is_a(X,Y), is_a(Y,X).
noLeastCommon(E) :- common(E), is_a(C,E), common(C), not equiv(C,E).
leastCommon(X) :- common(X), not noLeastCommon(X).
```

```
entity(X) :- part_of(X,_).
entity(X) :- part_of(_,X).
notAncestor(E) :- seed(S), entity(E), not part_of(S,E).
common(E) :- entity(E), not notAncestor(E).
equiv(X,Y) :- part_of(X,Y), part_of(Y,X).
noLeastCommon(E) :- common(E), part_of(C,E), common(C), not equiv(C,E).
leastCommon(X) :- common(X), not noLeastCommon(X).
```
