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



one sig Board {
    board: func Int->Int->State
}

-- No alive on negative indicies.
-- All valid cells just be dead or alive
-- Using one sig board

pred wellformed{
    all row,col: Int {
        (Board.board[row][col] = Alive or
        Board.board[row][col] = Dead)

        Board.board[row][col] = Alive implies {
            row>0 and col>0
        }
    }
      

}

run {wellformed} 