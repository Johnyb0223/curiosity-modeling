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

-- test wellformed tick sequence
pred no_wellformed_tick_sequence{
  -- there exists no tick sequence that has no graph
    no t: Tick | t.curr = none
    -- there exists no tick sequence that has a graph with no nodes
    no t: Tick |{
      some g:t.curr| g.nodes = none
    }
    -- there exists no two sequential ticks such that the graphs contain a different number of nodes
    no disj t1, t2: Tick | {
      #t1.curr.nodes != #t2.curr.nodes
      valid_next_tick[t1, t2]
    }
}

assert no_wellformed_tick_sequence is necessary for wellformed_universe
