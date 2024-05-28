input ----> game state
--------------------------------
input can be:
    - tapping on a square
    - selecting a promotion type
    - quiting the game
    - requesting to pause the game
    - accepting a pause request
    - draw offer
------------------------
game can be played:
    - same device:
        - two users
        - one user vs computer (stockfish)
    - two devices:
        - bluetooth
        - wifi direct
        - web rtc
        - intermediary server + web sockets:
----------------------
Same device:
    - all the logic should be proccessed locally
Two Devices:
    - No Intermediary Server:
        - Input from a user is processed on the same device and the game status is sent to the other user.
        - The Input from a user is processed on its device and the input is sent to the other device to also be processed.
    - With Intermediary Server:
        - The input of a user is processed on the server and the game state is sent to both users.
----------------------
Before making a decision on the game state, I need to see how it can be parsed into an official standard way like FEN, PNG, and Extended Position Description (EPD), so that it can later be handled by multiple Chess Engines like stockfish, even if I had to introduce an adapter in between.
//----------------------------
https://chess.stackexchange.com/questions/16601/connecting-chess-engine-with-a-java-program