#lang forge

-- vertex in the graph
sig Node {
    neighbors : set Node
}


sig Graph {
    -- the nodes of the graph
    nodes: set Node
    -- orginial design choice
    // edges: set  Edge
}

-- state what it means for a Node to be wellformed. 
-- These constraints are applied to all nodes in the universe
pred wellformed_node{
    -- node must be in a graph
    all n: Node| one g: Graph | n in g.nodes
    -- node is not its own neighbor
    all n: Node | not n in n.neighbors

}

-- describe what it means to be a wellformed graph
pred wellformed_graph{
    -- a node is only in one graph
    all disj g1,g2: Graph| {
        all n1: g1.nodes, n2: g2.nodes |{
            n1 in g1.nodes implies not n2 in g1.nodes
        }
    }
}

-- graph has at least one node
pred no_empty_graphs{
    all g: Graph | g.nodes != none

}

-- This is an undirected graph, so if n1 is a neighbor of n2, then n2 is a neighbor of n1
pred symmetrical_graph{
    all disj n1,n2: Node  |
        n1 in n2.neighbors implies n2 in n1.neighbors
}

-- more then one node in tgraph implies that all nodes have at least one neighbor
pred all_nodes_have_neighbors{
    all g: Graph |{
        all n: g.nodes | #g.nodes > 1 implies n.neighbors != none
    }
}

-- the graph is wellconnected
-- for any two nodes in the graph, there is a path between them
pred graph_connected{
    all g: Graph |
        all disj n1,n2: g.nodes |{
            reachable[n1,n2,^(neighbors)]
        }
}

-- nodes in different graphs cannot be neighbors
-- any two graphs are unique
pred no_cross_graph_neighbors{
    all disj g1,g2: Graph |{
        g1.nodes.^neighbors & g2.nodes.^neighbors = none
    }
}

-- state what it means for a graph to be wellformed
pred graph_wellformed{
    -- graph has wellformed nodes
    wellformed_node
    -- the graph has at least one node
    no_empty_graphs
    -- the relations amoung nodes are symmetric
    symmetrical_graph
    -- all nodes have at least one neighbor
    all_nodes_have_neighbors
    -- the graph is wellconnected
    graph_connected
    -- nodes in different graphs cannot be neighbors
    no_cross_graph_neighbors
}

pred wellformed_universe{
    -- there is at least one graph
    some Graph
    -- all graphs are wellformed
    graph_wellformed
}

-- see some wellformed graph examples
run {wellformed_universe} for exactly 3 Graph, exactly 9 Node

-- we want to bring the idea of steps into the model
-- a graph at a given time
sig Tick {
    next: lone Tick,
    curr: one Graph
}

-- no two Ticks share the same graph
pred tick_curr_unique{
    all disj t1,t2: Tick | t1.curr != t2.curr
}

-- valid transitions have structurally identical graphs
pred valid_next_tick[t1, t2 :Tick]{
    -- graph maintianss the same number of nodes
    #t1.curr.nodes = #t2.curr.nodes
    -- the number of nodes reachable from every node remains constant
    all n1: t1.curr.nodes, n2: t2.curr.nodes |{
        #n1.^neighbors = #n2.
        ^neighbors
        #n1.neighbors = #n2.neighbors
    } 
    
}

-- valid transitions beteween Ticks
pred wellformed_tick_sequence{
    all disj t1,t2: Tick | t1.next = t2 => valid_next_tick[t1, t2]
}

-- every Tick (moment) will have one graph and no two Ticks share the same graph
pred tick_wellformed{
    -- every Tick will have one graph
    all t: Tick | one g: Graph | g = t.curr
    --valid graphs
    graph_wellformed
    -- no two Ticks share the same graph
    tick_curr_unique
    -- valid transitions beteween Ticks
    wellformed_tick_sequence
}

-- see some wellformed sequence of Ticks
// run {graph_wellformed tick_wellformed} for  exactly 3 Tick, exactly 3 Graph, exactly 9 Node for {next is linear}