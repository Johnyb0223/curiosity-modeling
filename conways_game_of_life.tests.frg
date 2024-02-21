#lang forge/bsl 

open "conways_game_of_life.frg"

pred should_be_dead{
    all b:Board, row, col: Int{
        some Board.board[row][col]
        and
        (row<0 or col<0) implies  b.board[row][col] = Alive
    }
    }

pred not_wellformed {
    not wellformed
    }



test suite for wellformed{


    assert should_be_dead is sufficient for not_wellformed 

}