#lang forge

open "undir_graph.frg"


-- Test Wellformed Node
pred no_wellformed_node{
  -- there exists no node that is a neighbor of itself
    no n:Node | n in n.neighbors
  -- there exists no node the is in no graph
    no n:Node |{
      all g:Graph | not n in g.nodes
    }

}

assert wellformed_node is sufficient for no_wellformed_node

-- Test Wellformed Graph
pred no_wellformed_graph{
  -- there exists no graph that has zero nodes
    no g:Graph | g.nodes = none
    --there exists no graph that has more than 1 node and a node with no neighbors
    no g:Graph |{
      some n:g.nodes| n.neighbors = none
      #g.nodes != 1
    }
    -- if a graph has one node, it has no neighbors
    no g:Graph |{
       some n:g.nodes| {
      n.neighbors != none
      #g.nodes = 1}
    }
}

assert no_wellformed_graph is necessary for wellformed_universe
