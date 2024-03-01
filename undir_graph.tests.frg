#lang forge

open "undir_graph.frg"

-- no_empty graph should exists
pred some_empty_graph{some g: Graph | g.nodes = none}
pred not_empty_graph{ not some_empty_graph}
pred graphs_not_empty{
     all g: Graph |{
        some n: Node | n in g.nodes
     }
}
-- 
test suite for no_empty_graphs{
    assert not_empty_graph is necessary for no_empty_graphs
    assert graphs_not_empty is sufficient for no_empty_graphs
}

-- This is not undirected graph, so if n1 is a neighbor of n2 then n2 is a neighbor of n1
pred not_symmetrical_graph{
    all g: Graph | {
    all disj n1,n2: g.nodes  |
         n1 in n2.neighbors implies not n2 in n1.neighbors
    }
}
-- Negate a non symmetrical graph
pred not_not_symmetrical_graph{
     not not_symmetrical_graph
     graph_wellformed
}

-- two different nodes can be symmetric
pred symmetrical_graph_for_different_nodes{
    all n1,n2: Node  |{
        n1 != n2
        n1 in n2.neighbors implies n2 in n1.neighbors
    }
}
-- in this predicate, a node can be its own neighbor, and that imples that it's own neighbors.
pred symmetrical_graph_for_equal_nodes{
    all n1,n2: Node  |{
        n1 = n2
        n1 in n2.neighbors implies n2 in n1.neighbors
    }
}
-- symmertical_neighbors
test suite for symmetrical_graph{
    assert not_not_symmetrical_graph is sufficient for symmetrical_graph for 1 Graph
    assert symmetrical_graph_for_different_nodes is sufficient for symmetrical_graph
    assert symmetrical_graph_for_equal_nodes is sufficient for symmetrical_graph
}

-- more then one node in tgraph implies that all nodes have at least one neighbor
-- just because we neighbors  
pred some_nodes_no_neighbors{some n: Node | #n > 1 implies n.neighbors = none}
pred not_some_nodes_no_neighbors{not some_nodes_no_neighbors}
-- the number of neighors should be greater than 0.
pred neighbors_count{
    graph_wellformed
    all g: Graph {
    all n: Node | #(g.nodes) > 1 implies #(n.neighbors) > 0
    }
}

test suite for all_nodes_have_neighbors{
    assert not_some_nodes_no_neighbors is sufficient for all_nodes_have_neighbors 
    assert neighbors_count is sufficient for all_nodes_have_neighbors for exactly 2 Graph
}

-- two different nodes not equal should be reachable
pred graph_connected_different_nodes{
    all g: Graph |
        all  n1,n2: g.nodes |{
            n1 != n2
            reachable[n1,n2,^(neighbors)]
        }
}
-- two of the same nodes should be reachable.
pred graph_connected_same_nodes{
    all g: Graph |
        all  n1,n2: g.nodes |{
            n1 = n2
            reachable[n1,n2,^(neighbors)]
        }
}
-- nodes in graph not reachable -- graph not completely conntected. 
pred graph_connected_negative{
    one g: Graph |
        some  n1,n2: g.nodes {
            not reachable[n1,n2,^(neighbors)]
        }
}
-- negate above predicate.
pred not_graph_connected_negative{not graph_connected_negative}


test suite for graph_connected{
    assert graph_connected_different_nodes is sufficient for graph_connected
    assert graph_connected_same_nodes is sufficient for graph_connected   
    assert not_graph_connected_negative is sufficient for graph_connected for exactly 1 Graph
}
-- 
pred cross_graph_neighbors{
    all disj g1,g2: Graph |{
        g1.nodes.^neighbors & g2.nodes.^neighbors != none
    }
}
-- Size of cross graph union is 0.
pred cross_graph_neighbors_same_graph{
    graph_wellformed
    all g1,g2: Graph |{
        g1 = g2 implies #(g1.nodes.^neighbors & g2.nodes.^neighbors) = 0
    }
}

--
pred neg_CGN{
    wellformed_graph
    //graph_wellformed
    wellformed_node
    -- this only follows if the graph wellformed, which meabs neighbors are created properly.  
    not cross_graph_neighbors
}

test suite for no_cross_graph_neighbors {
    -- We are not testing for relations with ticks
    assert neg_CGN is sufficient for no_cross_graph_neighbors for exactly 0 Tick, exactly 2 Graph
    assert cross_graph_neighbors_same_graph is sufficient for no_cross_graph_neighbors 
}


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
