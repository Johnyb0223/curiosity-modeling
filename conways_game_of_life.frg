#lang forge

/**
Here is a model of the game of life (GOF)
The game is played over a graph space. The cells of the board are verticies. 
These verticies have a state (Alive or Dead) and exactly 8 neighbors of type cell 
We want to explore the dependancy of future graph states given an initial state. 
The game proceeds in generations, where each generation is a new graph state that is computed from the previous graph state according to the rules of the game.
By graph state we mean the SEQUENCE of Alive cells. This should be unique and independant of the board state 
The rules are simple and determine the next state of the verticie based on the current state and the state of its neighboors.
Notice how this is independant of any oredering since it only depends in how

Rules of Life:
1. Any live cell with fewer than two live neighbors dies, as if by underpopulation.
2. Any live cell with two or three live neighbors lives on to the next generation.
3. Any live cell with more than three live neighbors dies, as if by overpopulation.
4. Any dead cell with exactly three live neighbors becomes a live cell, as if by reproduction.
**/


-- Node is a vertex in the graph. It has a status of either true(1) or false(0)
sig Node {}

sig Edge {
    -- the two Nodes that the edge connects
    head : one Node,
    tail : one Node 
}

sig Graph {
    -- the nodes of the graph
    nodes: set Node,
    -- the set of edges that connect the cells
    edges: set  Edge
}

-- state what it means for an Edge to be wellformed
pred edge_wellformed_global{
    -- edge must be in a graph
    all e: Edge| some g: Graph | e in g.edges
}

-- state what it means for a Node to be wellformed. 
-- These constraints are applied to all nodes in the universe
pred wellformed_node_global{
    -- node must be in a graph
    all n: Node| some g: Graph | n in g.nodes
}

-- state what it means for an Edge to be wellformed
pred edge_wellformed_for_graph[g: Graph]{
    edge_wellformed_global
    -- the head and tail of the edge must be different
    all e: g.edges | e.head != e.tail
}

-- state what it means for a graph to be wellformed
pred graph_wellformed[g: Graph]{
    wellformed_node_global
    edge_wellformed_for_graph[g]
    -- the graph has at least one node
    some g.nodes
    -- 
    all disj n1,n2: g.nodes |
        some disj e1,e2 : g.edges |
        (e1.head = n1 and e1.tail = n2)
            implies (e2.head = n2 and e2.tail = n1)
        

}


run {  one g: Graph | graph_wellformed[g]} for 1 Graph
