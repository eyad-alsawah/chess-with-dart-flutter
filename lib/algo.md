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
    * draw 
    * timeout </br>
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
### Second Step:
* find the square where king is at
* get all the squares surrounding the king
* if any square contains a king &rarr; <span style="color:red">
Game Over

   
