1. Black king is not checked after promoting white pawn to queen with move c7c8: ✔️
from: r3kbnr/ppPbpppp/n2q4/3Q4/8/8/PPP1PPPP/RNB1KBNR w KQkq - 1 5
to: r1Q1kbnr/pp1bpppp/n2q4/3Q4/8/8/PPP1PPPP/RNB1KBNR b KQkq - 0 5
--------------------------
2. Can't move bishop with move d7c8 to remove the check: ✔️
from: Q3kbnr/pp1bpppp/n2q4/8/8/8/PPPQPPPP/RNB1KBNR b KQkq - 0 7
----------------------------
3. Black king can move on an adjacent square to white king: ✔️
from:  8/3K4/8/3k4/8/8/8/8 b - - 22 76
-----------------------------
4. Moving the pawn from d6c7 does not expose the black king to a check from the queen at d1: ✔️
rnbq1bnr/pppk1ppp/3P4/8/8/8/PPP1PPPP/RNBQKBNR w KQ - 1 3
------------------------
5. The black king is checked by the queen on d8 even tho there is a bishop in between at c8: ✔️
rQb1kbnr/pp3ppp/3q4/8/8/8/PPP1PPPP/RNBQKBNR b KQkq - 0 4 
------------------------
6. Black king on e4 is checked by enPassantTargetSquare at f4: ✔️
rn1B2nr/p4ppp/3b4/1p6/4k3/8/PPP1PPPP/RN2KBNR w KQ - 0 13
----------------
7. Black king can expose himself to check with move e8d7: ✔️
rnb1kbnr/ppp1Pppp/8/8/8/8/PPP1PPPP/RNBQKBNR b KQkq - 0 3
------------------------------------------
8. This position is not detected as stalemate even tho the white king has no where to go and isn't checked: ✔️
8/8/8/8/8/5k1q/8/6K1 w - - 3 3
-------------------------
9. Both a checkmate and a stalemate is detected with these moves: ✔️
1rb4r/pkPp3p/1b1P3n/1Q6/N3Pp2/8/P1P3PP/7K w - - 1 0 Qd5+ Ka6 2. cxb8=N#
-----------------------------------------------------
10. Black king is checked at g8 even tho it is not attacked: ✔️
5rk1/1pp2p1R/p1P4K/4p3/8/2n4B/n7/8 b - - 0 0
!! could not find a logical way in which a player might get himself in that position
---------------
11. Black king should not be checked: ✔️
r4bnr/1p3ppp/8/4P3/2B3k1/5N2/PPPN2PP/R3K2R b KQ - 3 16
--------------
12. White can't castle short castle: ✔️
 r7/1p2kpp1/5q1p/p7/1nBr4/2Q5/PP3PPP/3RK2R w K - 0 1 
 --------------
13. Should be checkmate on b5b7, king is not checkmated because the black king is treated as a pawn and thus not threating: ✔️
8/K4pp1/2k4p/1q6/p5PP/P7/8/8 b - - 0 37
--------------------
14. Incorrect UCI string on castling (example: "moves h1g1 e1g1" instead of "moves e1g1"): ✔️
r1bk3r/p2p1B1p/2p2pp1/8/1P6/8/P1P3PP/R3K2R w KQ - 0 18
----------------------------