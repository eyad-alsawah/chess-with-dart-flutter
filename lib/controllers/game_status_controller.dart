import 'package:chess/controllers/enums.dart';

import 'package:chess/model/global_state.dart';
import 'package:chess/model/chess_board_model.dart';
import 'package:chess/model/square.dart';
import 'package:chess/utils/extensions.dart';

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
    for (var element in ChessBoardModel.chessBoard) {
      if (element.piece == Pieces.king) {
        kingsCount++;
      }
    }
    return kingsCount == 1;
  }

  Future<bool> isKingSquareAttacked({
    required PlayingTurn playingTurn,
    Square? escapeSquare,
  }) async {
    PieceType openentKingType =
        playingTurn == PlayingTurn.white ? PieceType.light : PieceType.dark;
    Square oppenentKing = escapeSquare ??
        ChessBoardModel.getSquareAtPieceAndType(
                piece: Pieces.king, type: openentKingType)
            .copy();

    /// -------------------------------------getting surrounding openent pawns--------------------------
    List<Square> surroundingopenentPawns = basicMovesController.getPawnPieces(
        rank: oppenentKing.rank, file: oppenentKing.file);
    // pawns can't check a king of the same type
    surroundingopenentPawns
        .removeWhere((pawn) => pawn.pieceType == oppenentKing.pieceType);
    // pawns that are on the same file as the king aren't checking the king
    surroundingopenentPawns
        .removeWhere((pawn) => pawn.file == oppenentKing.file);
    surroundingopenentPawns.removeWhere((pawn) {
      // a black king can't be put in check by white pawns higher in rank
      if (oppenentKing.pieceType == PieceType.dark &&
          pawn.rank > oppenentKing.rank) {
        return true;
      }
      // a white king can't be put in check by white pawns lower in rank
      if (oppenentKing.pieceType == PieceType.light &&
          pawn.rank < oppenentKing.rank) {
        return true;
      }
      return false;
    });

    /// -------------------------------------getting surrounding openent knights---------------
    List<Square> surroundingKnights = basicMovesController.getKnightPieces(
        rank: oppenentKing.rank, file: oppenentKing.file);
    // knights of the same type as the openent king can't check the king
    surroundingKnights
        .removeWhere((knight) => knight.pieceType == openentKingType);
    // empty squares don't count, same for pieces that are not knights
    surroundingKnights.removeWhere(
        (square) => square.piece == null || square.piece != Pieces.knight);

    /// ------------------------------------getting surrounding openent rooks and queens  (queens vertical/horizontal to the openent king)---------
    List<Square> surroundingRooksAndQueens = [
      ...basicMovesController.getHorizontalPieces(
          rank: oppenentKing.rank, file: oppenentKing.file),
      ...basicMovesController.getVerticalPieces(
          rank: oppenentKing.rank, file: oppenentKing.file),
    ];

    List<Square> surroundingRooksAndQueensInLineOfSight =
        await legalMovesController.getLegalMovesOnly(
            legalAndIllegalMoves: surroundingRooksAndQueens,
            file: oppenentKing.file,
            rank: oppenentKing.rank);

    // rooks or queens of the same type as the king can't check the king
    surroundingRooksAndQueensInLineOfSight.removeWhere(
        (rookOrQueen) => rookOrQueen.pieceType == oppenentKing.pieceType);

    // empty squares don't count, same for pieces that are neither rooks nor queens
    surroundingRooksAndQueensInLineOfSight.removeWhere((square) =>
        square.piece == null ||
        (square.piece != Pieces.rook && square.piece != Pieces.queen));

    /// ----------------------------------------getting surrounding openent bishops and queens (queens diagonal to the openent king)----------------
    List<Square> surroundingBishopsAndQueens = basicMovesController
        .getDiagonalPieces(rank: oppenentKing.rank, file: oppenentKing.file);
    List<Square> surroundingBishopsAndQueensInLineOfSight =
        await legalMovesController.getLegalMovesOnly(
            legalAndIllegalMoves: surroundingBishopsAndQueens,
            file: oppenentKing.file,
            rank: oppenentKing.rank);

    surroundingBishopsAndQueensInLineOfSight.removeWhere(
        (bishopOrQueen) => bishopOrQueen.pieceType == oppenentKing.pieceType);
    // empty squares don't count, same for pieces that are neither bishops nor queens
    surroundingBishopsAndQueensInLineOfSight.removeWhere((square) =>
        square.piece == null ||
        (square.piece != Pieces.bishop && square.piece != Pieces.queen));

    ///------------------------------------------------------------------------------------

    return surroundingopenentPawns.isNotEmpty ||
        surroundingKnights.isNotEmpty ||
        surroundingRooksAndQueensInLineOfSight.isNotEmpty ||
        surroundingBishopsAndQueensInLineOfSight.isNotEmpty;
  }

  Future<bool> isCheckmate({required PlayingTurn attackedPlayer}) async {
    List<int> movesThatProtectTheKing = [];
    // a late initialization error should not occur, unless the logic is wrong
    late Square kingSquare;

    // find all the attacked player pieces expect the king
    // find all the legal moves for those pieces
    // move them and check if king is still attacked
    PieceType attackedPlayerType =
        attackedPlayer == PlayingTurn.white ? PieceType.light : PieceType.dark;
    List<Square> attackedPlayerPieces = [];
    for (var square in ChessBoardModel.chessBoard) {
      if (square.pieceType == attackedPlayerType) {
        if (square.piece == Pieces.king) {
          kingSquare = square.copy();
        } else {
          attackedPlayerPieces.add(square.copy());
        }
      }
    }

    List<Square> attackedPlayerLegalMoves = [];
    List<int> attackedPlayerLegalMovesIndices = [];
    for (var piece in attackedPlayerPieces) {
      List<Square> legalAndIllegalMoves = legalMovesController
          .getIllegalAndLegalMoves(rank: piece.rank, file: piece.file);
      List<Square> legalMovesOnly =
          await legalMovesController.getLegalMovesOnly(
              legalAndIllegalMoves: legalAndIllegalMoves.deepCopy(),
              file: piece.file,
              rank: piece.rank);
      List<int> legalMovesIndices =
          await legalMovesController.getLegalMovesIndices(
              tappedSquareFile: piece.file, tappedSquareRank: piece.rank);

      attackedPlayerLegalMoves.addAll(legalMovesOnly.deepCopy());
      attackedPlayerLegalMovesIndices.addAll(legalMovesIndices.deepCopy());
    }

    movesThatProtectTheKing.addAll(attackedPlayerLegalMovesIndices.deepCopy());

    for (var index in attackedPlayerLegalMovesIndices) {
      Square currentSquareAtIndex =
          ChessBoardModel.getSquareAtIndex(index).copy();
      // deep copy
      await ChessBoardModel.updateSquareAtIndex(
          index, Pieces.pawn, attackedPlayerType);

      if (await isKingSquareAttacked(playingTurn: attackedPlayer)) {
        movesThatProtectTheKing.removeWhere((moveIndex) => moveIndex == index);
      }

      ChessBoardModel.updateSquareAtIndex(
          index, currentSquareAtIndex.piece, currentSquareAtIndex.pieceType);
    }

    ///-----------------------------checking if king can move to safety
    List<int> kingLegalMovesIndices =
        await legalMovesController.getLegalMovesIndices(
            tappedSquareFile: kingSquare.file,
            tappedSquareRank: kingSquare.rank);

    List<int> kingMovesThatWouldProtectHim = [];
    kingMovesThatWouldProtectHim.addAll(kingLegalMovesIndices.deepCopy());

    for (var index in kingLegalMovesIndices) {
      int kingSquareIndex = ChessBoardModel.getIndexOfSquare(kingSquare);
      // the square we will temporarily move the king to for testing if the check remains.

      Square originalSquare = ChessBoardModel.getSquareAtIndex(index).copy();
      // emptying the square the king is currently on
      ChessBoardModel.emptySquareAtIndex(kingSquareIndex);

      // moving the king to the new square
      ChessBoardModel.updateSquareAtIndex(
          kingSquareIndex, Pieces.king, attackedPlayerType);
      //-----------------------
      if (await isKingSquareAttacked(playingTurn: attackedPlayer)) {
        kingMovesThatWouldProtectHim
            .removeWhere((moveIndex) => moveIndex == index);
      }
      // resetting the square to its original state
      ChessBoardModel.updateSquareAtIndex(
          kingSquareIndex, originalSquare.piece, originalSquare.pieceType);
      // moving the king back to its original square
      ChessBoardModel.updateSquareAtIndex(
          kingSquareIndex, Pieces.king, attackedPlayerType);
      //----------------------------------
    }

    return kingMovesThatWouldProtectHim.isEmpty &&
        movesThatProtectTheKing.isEmpty;
  }

  Future<bool> checkForStaleMate({required PieceType opponentKingType}) async {
    int opponentKingIndex = ChessBoardModel.getIndexWherePieceAndPieceTypeMatch(
        Pieces.king, opponentKingType,
        matchPiece: true, matchType: true);
    // checking for stalemate
    List<int> allLegalMovesIndices = [];
    for (var square in ChessBoardModel.chessBoard) {
      if (square.pieceType ==
          ChessBoardModel.getSquareAtIndex(opponentKingIndex).pieceType) {
        allLegalMovesIndices
            .addAll(await legalMovesController.getLegalMovesIndices(
          tappedSquareFile: square.file,
          tappedSquareRank: square.rank,
          isKingChecked: sharedState.isKingInCheck,
          fromHandleSquareTapped: true,
        ));
      }
    }
    // player has no legal move and an empty square was not tapped
    if (allLegalMovesIndices.isEmpty &&
        ChessBoardModel.getSquareAtIndex(opponentKingIndex).pieceType != null) {
      helperMethods.preventFurtherInteractions(true);
      callbacks.onDraw(DrawType.stalemate);
      return true;
    }
    return false;
  }
}
