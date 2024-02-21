#lang forge/bsl 
/**
In the game, cells evolve through generations according to the following rules:
1. Any live cell with fewer than two live neighbors dies, as if by underpopulation.
2. Any live cell with two or three live neighbors lives on to the next generation.
3. Any live cell with more than three live neighbors dies, as if by overpopulation.
4. Any dead cell with exactly three live neighbors becomes a live cell, as if by reproduction.
**/


abstract sig State{}
one sig Alive, Dead extends State{}


sig Board {
    board: func Int->Int->State
}

one sig Game{
    initialState: one Board,
    next: pfunc Board->Board
}

-- No alive on negative indicies.
-- All valid cells just be dead or alive
-- Using one sig board

pred wellformed{
    all b:Board, row,col: Int {
        (b.board[row][col] = Alive or
        b.board[row][col] = Dead)

        b.board[row][col] = Alive implies {
            row>0 and col>0
        }
    }

}

pred live_or_die[board: Board, row,col: Int]{
    
}


pred valid_next_board[current: Board, next: Board]{

}

run {wellformed} 