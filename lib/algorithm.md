## **Chess Algorithm**
1. if any of the following:   
    * only one king exists, or more than one king for each player
    * two kings are adjacent to each other
    * checkmate
    * draw  </br>
    &rarr; <span style="color:red">
Game Over
</span> </br>
1. else &rarr; player can move
2. if:
    * checkmate
    * draw </br>
    &rarr; <span style="color:red">
Game Over
</span> </br>
4 . else &rarr; goto 2
---  
### First Step:
* only one king exists, or more than one king for each player:
    1. create two counters for the number of kings of each player: lightKingsCount/darkKingsCount
    2. for each square on the board:
        * if square is not empty && square is occupied by a king </br>
        &rarr; if king is light? lightKingsCount++: darkKingsCount++
    3. if lightKingsCount or darkKingsCount != 1 &rarr; <span style="color:red">
Game Over
---
* two kings are adjacent to each other
    * find the square where king is at
    * get all the squares surrounding the king 
    * if any square contains a king &rarr; <span style="color:red">
Game Over
---
 * checkmate when:  (for first and second step)
    * king is checked & player can neither move king to safety nor take the attacking piece
    * one of the players' time runs out
    * one of the players resigns
----- 
* draw when: (for first and second step)
  * insufficient material (includes dead positions)
  * stalemate
  * 50-move rule
  * mutual agreement
  * threefold repetition
---
### **Testing For Checkmate**:
* king is checked & player can neither move king to safety nor take the attacking piece:
   * king is checked:
        * get pawn squares, and for each square, check if an enemy pawn exists
        * get knight pieces, and for each square, check if an enemy knight exists
        * get vertical/horizontal pieces, and for each square, check if either an enemy rook/queen exist.
        * get diagonal pieces, and for each square, check if either an enemy bishop/queen exist.
    * player can neither move king to safety nor take the attacking piece:
        * get king squares, and for each square:
        * get pawn squares, and for each square, check if an enemy pawn exists
        * get knight pieces, and for each square, check if an enemy knight exists
        * get vertical/horizontal pieces, and for each square, check if either an enemy rook/queen exist.
        * get diagonal pieces, and for each square, check if either an enemy bishop/queen exist. 
* one of the players' time runs out:
        * for each player create a timer, and pause the timer if it isn't a player's turn
        * if either player's time runs out, the other player wins
---
### **Testing For Draw:**
  * insufficient material (includes dead positions):
    * no pawns on the board &&:
      * king vs king
      * king + m * bishops (all bishops are on the same color)  vs king
      * king + m * bishops (all bishops are on the same color)  vs  king + n * bishops (all bishops are on the same color as the enemy's bishops) 
      * king + knight vs king
      * blocked position (dead position) 
  * stalemate: player is not in check && has no legal move
  * no capture is made && no pawn is moved for 50 consecutive moves
  * mutual agreement
  * threefold repetition, happens when all the following conditions are met:
      *  same positions for all the pieces happened three times.
      *  for each repeated position it was the turn of the same player to play.
      *  for each repeated position all the pieces had the same possible moves.
    

