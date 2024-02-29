# Project Objective:

Conways game of life was the original objective of the model. We quickly found it very difficult to represent a sound game with the finite boards that could be represented with a `pfunc` or `func`. Each `cell` on the board in conways game of life has eight neighbors. The state of these neighbors soley determines the current cells state in the next step of time. This requires the idea of an infinte board. The idea that every cell has exaclty eight neighbors. We found that a graph structure would be sufficient to represent the board.

Here we have modeled an undirected graph and the idea of wellformed sequential graph states. With this model we could constrain the graph to a desired board state and simulate the game of life.

# Model Design and Visualization:

**Definition `Node`:**

- a node is a non-divisible entity. An atom in the universe.
- A node has a set of zero or more nodes connected to it. These are the `neighbors` of the node
- A node cannot be its own neighbor

**Definition `Graph`**

- a `graph` is a set of nodes.
- The graph is undirected, if node `a` is a neighbor of node `b`, then node `b` is a neighbor of node `a`

**Definition `wellformed_graph`**

- has a at least one node
- if there is more then one node, then every node has at least one neighbor.
- every node is reachable from every other node

**Deinition `Tick`**

- A `tick` is a non-divisible atom in our model. It represents a step in time.
- A tick has one next tick. This is the next linear moment in time
- A tick has one `[curr]ent` state. This is the state of the graph at the current tick

**Definition `valid_next_tick[t1: Tick,t2: Tick]`**

- A `valid_next_tick` is a valid transition from one tick to the next tick
- a valid transition is a transition where sizeof(t1.curr.nodes) = sizeof(t2.curr.nodes)
- a valid transition is a transition where for every node in t1.curr.nodes there is some node in t2.curr.nodes such that sizeof(node1.neighbors) = sizeof(node2.neighbors)

**Definition `Sequential Graph States`**

- A `sequential_graph_state` is a sequence of ticks where each tick is a `valid_next_tick` from the previous tick

# Testing:

#### TODO

What tests did you write to test your model itself? What tests did you write to verify properties about your domain area?
Feel free to give a high-level overview of this.

# Interesting Observations:

- A wellformed sequence of ticks in our model maintains the structure of the graph. What is interesting is that this property was enforced solely by constraining two properties of the graph. The number of nodes in the graph and the number of neighbors that each node has.
