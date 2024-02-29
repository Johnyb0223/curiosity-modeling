#lang forge

open "undir_graph.frg"


-- The game of life is well-formed if no cell is its own neighbor
pred no_cell_is_its_own_neighbor{
  no c: Cell | c in c.neighbors
}

-- The game of life is well-formed if every cell has exactly 8 neighbors
pred every_cell_has_exactly_8_neighbors{
  all c: Cell | #c.neighbors = 8
}

-- c1 is a neighbor of c2 if and only if c2 is a neighbor of c1
pred neighbors_are_symmetric{
    all c1, c2: Cell | c1 in c2.neighbors <=> c2 in c1.neighbors
}

-- INTERSTING PROPERTY
-- PROOF: each cell having exactly 8 neighbors AND no cell being its own neighbor is sufficient for (c1 in c2.neighbors iff c2 in c1.neighbors) when the 
-- number of cells is 9 (instance space is 9)
pred weaker_welformed {
    every_cell_has_exactly_8_neighbors
    no_cell_is_its_own_neighbor
}
assert weaker_welformed is sufficient for neighbors_are_symmetric for 9 Cell
-- END PROOF


assert wellformed is sufficient for no_cell_is_its_own_neighbor for 9 Cell
assert wellformed is sufficient for every_cell_has_exactly_8_neighbors for 9 Cell
assert wellformed is sufficient for neighbors_are_symmetric for 20 Cell

