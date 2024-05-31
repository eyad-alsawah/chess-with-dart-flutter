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
