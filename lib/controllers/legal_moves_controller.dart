import 'package:chess/controllers/castling_controller.dart';
import 'package:chess/controllers/enums.dart';
import 'package:chess/controllers/shared_state.dart';
import 'package:chess/model/global_state.dart';
import 'package:chess/model/chess_board_model.dart';

import 'package:chess/model/square.dart';
import 'package:chess/utils/debug_config.dart';
import 'package:chess/utils/extensions.dart';

class LegalMovesController {
  // Private constructor
  LegalMovesController._private();

  // Private static instance
  static final LegalMovesController _instance = LegalMovesController._private();

  // Public static method to access the instance
  static LegalMovesController get instance => _instance;
  //----------------------------------------------------------------------------

  Future<List<int>> getLegalMovesIndices({
    required int from,
    bool isKingChecked = false,
    bool ignorePlayingTurn = true,
  }) async {
    if (!ignorePlayingTurn &&
        helperMethods.selectedPieceDoesNotMatchCurrentPlayingTurn(
            selectedPiece: from.toSquare())) {
      return [];
    }
    // getting all the moves a piece can move to if there was nothing standing in its way
    List<int> legalAndIllegalMoves = getIllegalAndLegalMoves(from);

    if (DebugConfig.displayAllLegalAndIllegalMoves) {
      SharedState.instance.debugHighlightIndices.clear();
      SharedState.instance.debugHighlightIndices.addAll(legalAndIllegalMoves);
    } else {
      SharedState.instance.debugHighlightIndices.clear();
    }

    // filtering out illegal moves
    List<int> legalMovesOnly = await getLegalMovesOnly(
        from: from,
        legalAndIllegalMoves: legalAndIllegalMoves.deepCopy(),
        fromHandleSquareTapped: !ignorePlayingTurn,
        kingChecked: isKingChecked);

    return legalMovesOnly;
  }

  //----------------------------------------------------------------------------------

  Future<List<int>> getLegalMovesOnly(
      {required List<int> legalAndIllegalMoves,
      required int from,
      bool fromHandleSquareTapped = false,
      bool kingChecked = false}) async {
    List<int> legalMoves = [];

    bool didCaptureOnRankLeft = false;
    bool didCaptureOnRankRight = false;
    bool didCaptureOnFileTop = false;
    bool didCaptureOnFileBottom = false;
    bool didCaptureOnDiagonalTopLeft = false;
    bool didCaptureOnDiagonalTopRight = false;
    bool didCaptureOnDiagonalBottomLeft = false;
    bool didCaptureOnDiagonalBottomRight = false;

    // for castling: to prevent the king from castling if any piece stands between the king and the rook
    legalAndIllegalMoves =
        CastlingController.preventCastlingIfPieceStandsBetweenRookAndKing(
            from: from, legalAndIllegalMoves: legalAndIllegalMoves.deepCopy());

    for (var move in legalAndIllegalMoves) {
      RelativeDirection relativeDirection =
          helperMethods.getRelativeDirection(from: from, to: move);

      bool fromEmptySquare = from.toPieceType() == null;
      bool toEmptySquare = move.toPiece() == null;
      bool toOppositeType = move.toPieceType() != from.toPieceType();

      if (fromEmptySquare) {
        legalMoves.clear();
      } else if (from.toPiece() == Pieces.knight) {
        // treated differently than other pieces due to the way the knight moves
        (move.toPiece() == null || move.toPieceType() != from.toPieceType())
            ? legalMoves.add(move)
            : null;
      } else {
        switch (relativeDirection) {
          case RelativeDirection.rankLeft:
            if (toEmptySquare) {
              didCaptureOnRankLeft ? null : legalMoves.add(move);
            } else if (!didCaptureOnRankLeft) {
              toOppositeType ? legalMoves.add(move) : null;
              didCaptureOnRankLeft = true;
            }
            break;
          case RelativeDirection.rankRight:
            if (toEmptySquare) {
              didCaptureOnRankRight ? null : legalMoves.add(move);
            } else if (!didCaptureOnRankRight) {
              toOppositeType ? legalMoves.add(move) : null;
              didCaptureOnRankRight = true;
            }
            break;
          case RelativeDirection.fileTop:
            if (toEmptySquare) {
              didCaptureOnFileTop ? null : legalMoves.add(move);
            } else if (!didCaptureOnFileTop) {
              toOppositeType ? legalMoves.add(move) : null;
              didCaptureOnFileTop = true;
            }
            break;
          case RelativeDirection.fileBottom:
            if (toEmptySquare) {
              didCaptureOnFileBottom ? null : legalMoves.add(move);
            } else if (!didCaptureOnFileBottom) {
              toOppositeType ? legalMoves.add(move) : null;
              didCaptureOnFileBottom = true;
            }
            break;
          case RelativeDirection.diagonalTopLeft:
            if (toEmptySquare) {
              didCaptureOnDiagonalTopLeft ? null : legalMoves.add(move);
            } else if (!didCaptureOnDiagonalTopLeft) {
              toOppositeType ? legalMoves.add(move) : null;
              didCaptureOnDiagonalTopLeft = true;
            }
            break;
          case RelativeDirection.diagonalTopRight:
            if (toEmptySquare) {
              didCaptureOnDiagonalTopRight ? null : legalMoves.add(move);
            } else if (!didCaptureOnDiagonalTopRight) {
              toOppositeType ? legalMoves.add(move) : null;
              didCaptureOnDiagonalTopRight = true;
            }
            break;
          case RelativeDirection.diagonalBottomLeft:
            if (toEmptySquare) {
              didCaptureOnDiagonalBottomLeft ? null : legalMoves.add(move);
            } else if (!didCaptureOnDiagonalBottomLeft) {
              toOppositeType ? legalMoves.add(move) : null;
              didCaptureOnDiagonalBottomLeft = true;
            }
            break;
          case RelativeDirection.diagonalBottomRight:
            if (toEmptySquare) {
              didCaptureOnDiagonalBottomRight ? null : legalMoves.add(move);
            } else if (!didCaptureOnDiagonalBottomRight) {
              toOppositeType ? legalMoves.add(move) : null;
              didCaptureOnDiagonalBottomRight = true;
            }
            break;
          default:
            break;
        }
      }
    }

    // filtering legal moves to prevent moving to a place that would not remove the check
    if (kingChecked) {
      // in this step we place a piece on the legal moves square of the tapped piece and see if the king would still be checked or not.
      legalMoves = await preventMovingIfCheckRemains(
          legalMoves: legalMoves.deepCopy(), to: from);
    }
    // todo: causing problems needs fixing
    legalMoves = await filterMoveThatExposeKingToCheck(
        legalMoves.deepCopy(), from, fromHandleSquareTapped);

    return legalMoves.deepCopy();
  }

  Future<List<int>> filterMoveThatExposeKingToCheck(
      List<int> legalMoves, int from, bool fromHandleSquareTapped) async {
    if (fromHandleSquareTapped) {
      PieceType? fromType = from.toPieceType();
      Pieces? fromPiece = from.toPiece();

      // deep copying the list to prevent Concurrent modification of legalMoves
      for (var move in legalMoves.deepCopy()) {
        PieceType? moveType = move.toPieceType();
        Pieces? movePiece = move.toPiece();

        //--------------------

        // emptying the square we are at currently
        await ChessBoardModel.emptySquareAtIndex(from);

        // updating the square at move
        await ChessBoardModel.updateSquareAtIndex(
          move,
          fromPiece,
          fromType,
        );

        // here we are checking if the escape square is attacked instead of the tapped square in case the tapped piece is a king, because here we are hypothetically moving a king not another piece
        bool isKingAttacked = await gameStatusController.isKingSquareAttacked(
            attackedKingType: fromType,
            escapeTo: fromPiece == Pieces.king ? move : null);

        // resetting the hypothetically moved pieces
        await ChessBoardModel.updateSquareAtIndex(from, fromPiece, fromType);
        await ChessBoardModel.updateSquareAtIndex(move, movePiece, moveType);
        isKingAttacked ? legalMoves.remove(move) : null;
      }
    }

    return legalMoves;
  }

  Future<void> updateViewAndWait() async {
    callbacks.updateView();
    await Future.delayed(const Duration(milliseconds: 2000));
    callbacks.updateView();
  }

  Future<List<int>> preventMovingIfCheckRemains(
      {required List<int> legalMoves, required int to}) async {
    // in this step we place a piece on the legal moves square of the tapped piece and see if the king would still be checked or not.
    for (var index in legalMoves.deepCopy()) {
      Square currentSquareAtIndex = index.toSquare().copy();
      ChessBoardModel.updateSquareAtIndex(
          index, to.toPiece(), to.toPieceType());

      // here we are checking if the escape square is attacked instead of the tapped square in case the tapped piece is a king, because here we are hypothetically moving a king not another piece
      bool isKingAttacked = await gameStatusController.isKingSquareAttacked(
          escapeTo: to.toPiece() == Pieces.king ? index : null,
          attackedKingType: to.toPieceType());

      if (isKingAttacked) {
        legalMoves.removeWhere((move) =>
            move.toFile() == index.toFile() && move.toRank() == index.toRank());
      }
      // resetting the hypothetically moved piece
      ChessBoardModel.updateSquareAtIndex(
          index, currentSquareAtIndex.piece, currentSquareAtIndex.pieceType);
    }

    return legalMoves;
  }
  //----------------------------------------------------------------------------

  List<int> getIllegalAndLegalMoves(int from) {
    List<int> moves = [];
    // Define a map to associate each piece type with its move calculation function
    final Map<Pieces, List<int> Function()> moveFunctions = {
      Pieces.rook: () =>
          basicMovesController.getHorizontalPieces(from) +
          basicMovesController.getVerticalPieces(from),
      Pieces.knight: () => basicMovesController.getKnightPieces(from),
      Pieces.bishop: () => basicMovesController.getDiagonalPieces(from),
      Pieces.queen: () =>
          basicMovesController.getHorizontalPieces(from) +
          basicMovesController.getVerticalPieces(from) +
          basicMovesController.getDiagonalPieces(from),
      Pieces.king: () => basicMovesController.getKingPieces(from),
      Pieces.pawn: () => basicMovesController.getPawnPieces(from),
    };

    // Use the map to get the corresponding moves for the tapped piece
    moves = moveFunctions[from.toPiece()]?.call() ?? [];

    return moves;
  }
}
