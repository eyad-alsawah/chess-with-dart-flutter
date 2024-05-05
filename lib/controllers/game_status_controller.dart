import 'package:chess/controllers/enums.dart';

import 'package:chess/model/global_state.dart';
import 'package:chess/model/model.dart';
import 'package:chess/model/square.dart';

class GameStatusController {
  // Private constructor
  GameStatusController._private();

  // Private static instance
  static final GameStatusController _instance = GameStatusController._private();

  // Public static method to access the instance
  static GameStatusController get instance => _instance;
  //----------------------------------------------------------------------------

  bool doesOnlyOneKingExists() {
    int kingsCount = 0;
    for (var element in chessBoard) {
      if (element.piece == Pieces.king) {
        kingsCount++;
      }
    }
    return kingsCount == 1;
  }

  bool doesAnyPlayerHaveMoreThanOneKing() {
    int whiteKingsCount = 0;
    int blackKingsCount = 0;
    for (var element in chessBoard) {
      if (element.piece == Pieces.king) {
        element.pieceType == PieceType.light
            ? whiteKingsCount++
            : blackKingsCount++;
      }
    }
    return whiteKingsCount > 1 || blackKingsCount > 1;
  }

  bool isAnyKingAdjacentToAnotherKing() {
    for (var element in chessBoard) {
      if (element.piece == Pieces.king) {
        List<Square> surroundingPieces = basicMovesController.getKingPieces(
            rank: element.rank, file: element.file);
        for (var square in surroundingPieces) {
          if (square.piece == Pieces.king) {
            return true;
          }
        }
      }
    }
    return false;
  }

  bool isKingSquareAttacked(
      {required PlayingTurn playingTurn, Square? escapeSquare}) {
    PieceType enemyKingType =
        playingTurn == PlayingTurn.white ? PieceType.light : PieceType.dark;
    Square enemyKingPiece = escapeSquare ??
        chessBoard.firstWhere((square) =>
            square.piece == Pieces.king && square.pieceType == enemyKingType);

    /// -------------------------------------getting surrounding enemy pawns--------------------------
    List<Square> surroundingEnemyPawns = basicMovesController.getPawnPieces(
        rank: enemyKingPiece.rank, file: enemyKingPiece.file);
    // pawns can't check a king of the same type
    surroundingEnemyPawns
        .removeWhere((pawn) => pawn.pieceType == enemyKingPiece.pieceType);
    // pawns that are on the same file as the king aren't checking the king
    surroundingEnemyPawns
        .removeWhere((pawn) => pawn.file == enemyKingPiece.file);
    surroundingEnemyPawns.removeWhere((pawn) {
      // a black king can't be put in check by white pawns higher in rank
      if (enemyKingPiece.pieceType == PieceType.dark &&
          pawn.rank > enemyKingPiece.rank) {
        return true;
      }
      // a white king can't be put in check by white pawns lower in rank
      if (enemyKingPiece.pieceType == PieceType.light &&
          pawn.rank < enemyKingPiece.rank) {
        return true;
      }
      return false;
    });

    /// -------------------------------------getting surrounding enemy knights---------------
    List<Square> surroundingKnights = basicMovesController.getKnightPieces(
        rank: enemyKingPiece.rank, file: enemyKingPiece.file);
    // knights of the same type as the enemy king can't check the king
    surroundingKnights
        .removeWhere((knight) => knight.pieceType == enemyKingPiece.pieceType);
    // empty squares don't count, same for pieces that are not knights
    surroundingKnights.removeWhere(
        (square) => square.piece == null || square.piece != Pieces.knight);

    /// ------------------------------------getting surrounding enemy rooks and queens  (queens vertical/horizontal to the enemy king)---------
    List<Square> surroundingRooksAndQueens = [
      ...basicMovesController.getHorizontalPieces(
          rank: enemyKingPiece.rank, file: enemyKingPiece.file),
      ...basicMovesController.getVerticalPieces(
          rank: enemyKingPiece.rank, file: enemyKingPiece.file),
    ];
    List<Square> surroundingRooksAndQueensInLineOfSight =
        legalMovesController.getLegalMovesOnly(
            legalAndIllegalMoves: surroundingRooksAndQueens,
            file: enemyKingPiece.file,
            rank: enemyKingPiece.rank);
    // rooks or queens of the same type as the king can't check the king
    surroundingRooksAndQueensInLineOfSight.removeWhere(
        (rookOrQueen) => rookOrQueen.pieceType == enemyKingPiece.pieceType);
    // empty squares don't count, same for pieces that are neither rooks nor queens
    surroundingRooksAndQueensInLineOfSight.removeWhere((square) =>
        square.piece == null ||
        (square.piece != Pieces.rook && square.piece != Pieces.queen));

    /// ----------------------------------------getting surrounding enemy bishops and queens (queens diagonal to the enemy king)----------------
    List<Square> surroundingBishopsAndQueens =
        basicMovesController.getDiagonalPieces(
            rank: enemyKingPiece.rank, file: enemyKingPiece.file);
    List<Square> surroundingBishopsAndQueensInLineOfSight =
        legalMovesController.getLegalMovesOnly(
            legalAndIllegalMoves: surroundingBishopsAndQueens,
            file: enemyKingPiece.file,
            rank: enemyKingPiece.rank);
    surroundingBishopsAndQueensInLineOfSight.removeWhere(
        (bishopOrQueen) => bishopOrQueen.pieceType == enemyKingPiece.pieceType);
    // empty squares don't count, same for pieces that are neither bishops nor queens
    surroundingBishopsAndQueensInLineOfSight.removeWhere((square) =>
        square.piece == null ||
        (square.piece != Pieces.bishop && square.piece != Pieces.queen));

    ///------------------------------------------------------------------------------------

    return surroundingEnemyPawns.isNotEmpty ||
        surroundingKnights.isNotEmpty ||
        surroundingRooksAndQueensInLineOfSight.isNotEmpty ||
        surroundingBishopsAndQueensInLineOfSight.isNotEmpty;
  }

  bool isCheckmate({required PlayingTurn attackedPlayer}) {
    List<int> movesThatProtectTheKing = [];
    // a late initialization error should not occur, unless the logic is wrong
    late Square kingSquare;

    // find all the attacked player pieces expect the king
    // find all the legal moves for those pieces
    // move them and check if king is still attacked
    PieceType attackedPlayerType =
        attackedPlayer == PlayingTurn.white ? PieceType.light : PieceType.dark;
    List<Square> attackedPlayerPieces = [];
    for (var square in chessBoard) {
      if (square.pieceType == attackedPlayerType) {
        if (square.piece == Pieces.king) {
          kingSquare = square;
        } else {
          attackedPlayerPieces.add(square);
        }
      }
    }
    List<Square> attackedPlayerLegalMoves = [];
    List<int> attackedPlayerLegalMovesIndices = [];
    for (var piece in attackedPlayerPieces) {
      List<Square> legalAndIllegalMoves = legalMovesController
          .getIllegalAndLegalMoves(rank: piece.rank, file: piece.file);
      List<Square> legalMovesOnly = legalMovesController.getLegalMovesOnly(
          legalAndIllegalMoves: legalAndIllegalMoves,
          file: piece.file,
          rank: piece.rank);
      List<int> legalMovesIndices = legalMovesController.getLegalMovesIndices(
          tappedSquareFile: piece.file, tappedSquareRank: piece.rank);
      attackedPlayerLegalMoves.addAll(legalMovesOnly);
      attackedPlayerLegalMovesIndices.addAll(legalMovesIndices);
    }

    movesThatProtectTheKing.addAll(attackedPlayerLegalMovesIndices);

    for (var index in attackedPlayerLegalMovesIndices) {
      Square currentSquareAtIndex = chessBoard[index];
      // deep copy
      chessBoard[index] = Square(
        file: chessBoard[index].file,
        rank: chessBoard[index].rank,
        piece: Pieces.pawn,
        pieceType: attackedPlayerType,
      );
      if (isKingSquareAttacked(playingTurn: attackedPlayer)) {
        movesThatProtectTheKing.removeWhere((moveIndex) => moveIndex == index);
      }
      chessBoard[index] = currentSquareAtIndex;
    }

    ///-----------------------------checking if king can move to safety
    List<int> kingLegalMovesIndices = legalMovesController.getLegalMovesIndices(
        tappedSquareFile: kingSquare.file, tappedSquareRank: kingSquare.rank);

    List<int> kingMovesThatWouldProtectHim = [];
    kingMovesThatWouldProtectHim.addAll(kingLegalMovesIndices);
    for (var index in kingLegalMovesIndices) {
      Square currentSquare = Square(
          file: chessBoard[index].file,
          rank: chessBoard[index].rank,
          piece: chessBoard[index].piece,
          pieceType: chessBoard[index].pieceType);
      chessBoard[index] = Square(
          file: chessBoard[index].file,
          rank: chessBoard[index].rank,
          piece: Pieces.king,
          pieceType: attackedPlayerType);
      if (isKingSquareAttacked(playingTurn: attackedPlayer)) {
        kingMovesThatWouldProtectHim
            .removeWhere((moveIndex) => moveIndex == index);
      }
      chessBoard[index] = currentSquare;
    }
    return kingMovesThatWouldProtectHim.isEmpty &&
        movesThatProtectTheKing.isEmpty;
  }

  bool checkForStaleMate({required PieceType opponentKingType}) {
    int opponentKingIndex = chessBoard.indexWhere((square) =>
        square.piece == Pieces.king && square.pieceType == opponentKingType);
    // checking for stalemate
    List<int> allLegalMovesIndices = [];
    for (var square in chessBoard) {
      if (square.pieceType == chessBoard[opponentKingIndex].pieceType) {
        allLegalMovesIndices.addAll(legalMovesController.getLegalMovesIndices(
          tappedSquareFile: square.file,
          tappedSquareRank: square.rank,
          isKingChecked: sharedState.isKingInCheck,
          fromHandleSquareTapped: true,
        ));
      }
    }
    // player has no legal move and an empty square was not tapped
    if (allLegalMovesIndices.isEmpty &&
        chessBoard[opponentKingIndex].pieceType != null) {
      helperMethods.preventFurtherInteractions(true);
      callbacks.onDraw(DrawType.stalemate);
      return true;
    }
    return false;
  }
}
