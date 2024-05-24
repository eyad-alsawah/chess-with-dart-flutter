import 'package:chess/controllers/castling_controller.dart';
import 'package:chess/controllers/enums.dart';
import 'package:chess/controllers/helper_methods.dart';
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
    List<Square> legalAndIllegalMoves = getIllegalAndLegalMoves(from);

    if (DebugConfig.displayAllLegalAndIllegalMoves) {
      SharedState.instance.debugHighlightIndices.clear();
      SharedState.instance.debugHighlightIndices.addAll(
          HelperMethods.instance.squaresToIndices(legalAndIllegalMoves));
    } else {
      SharedState.instance.debugHighlightIndices.clear();
    }

    // filtering out illegal moves
    List<Square> legalMovesOnly = await getLegalMovesOnly(
        from: from,
        legalAndIllegalMoves: legalAndIllegalMoves.deepCopy(),
        fromHandleSquareTapped: !ignorePlayingTurn,
        kingChecked: isKingChecked);

    return HelperMethods.instance.squaresToIndices(legalMovesOnly);
  }

  //----------------------------------------------------------------------------------

  Future<List<Square>> getLegalMovesOnly(
      {required List<Square> legalAndIllegalMoves,
      required int from,
      bool fromHandleSquareTapped = false,
      bool kingChecked = false}) async {
    List<Square> legalMoves = [];

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
      RelativeDirection relativeDirection = helperMethods.getRelativeDirection(
          from: from, to: ChessBoardModel.getIndexOfSquare(move));

      if (from.toPieceType() == null) {
        legalMoves.clear();
      } else if (from.toPiece() == Pieces.knight) {
        // treated differently than other pieces due to the way the knight moves
        (move.piece == null || move.pieceType != from.toPieceType())
            ? legalMoves.add(move)
            : null;
      } else if (move.piece == null) {
        switch (relativeDirection) {
          case RelativeDirection.rankLeft:
            if (!didCaptureOnRankLeft) {
              legalMoves.add(move);
            }
            break;
          case RelativeDirection.rankRight:
            if (!didCaptureOnRankRight) {
              legalMoves.add(move);
            }
            break;
          case RelativeDirection.fileTop:
            if (!didCaptureOnFileTop) {
              legalMoves.add(move);
            }
            break;
          case RelativeDirection.fileBottom:
            if (!didCaptureOnFileBottom) {
              legalMoves.add(move);
            }
            break;
          case RelativeDirection.diagonalTopLeft:
            if (!didCaptureOnDiagonalTopLeft) {
              legalMoves.add(move);
            }
            break;
          case RelativeDirection.diagonalTopRight:
            if (!didCaptureOnDiagonalTopRight) {
              legalMoves.add(move);
            }
            break;
          case RelativeDirection.diagonalBottomLeft:
            if (!didCaptureOnDiagonalBottomLeft) {
              legalMoves.add(move);
            }
            break;
          case RelativeDirection.diagonalBottomRight:
            if (!didCaptureOnDiagonalBottomRight) {
              legalMoves.add(move);
            }
            break;
          default:
            break;
        }
      } else {
        if (move.pieceType == from.toPieceType()) {
          switch (relativeDirection) {
            case RelativeDirection.rankLeft:
              didCaptureOnRankLeft = true;
              break;
            case RelativeDirection.rankRight:
              didCaptureOnRankRight = true;

              break;
            case RelativeDirection.fileTop:
              didCaptureOnFileTop = true;

              break;
            case RelativeDirection.fileBottom:
              didCaptureOnFileBottom = true;

              break;
            case RelativeDirection.diagonalTopLeft:
              didCaptureOnDiagonalTopLeft = true;

              break;
            case RelativeDirection.diagonalTopRight:
              didCaptureOnDiagonalTopRight = true;

              break;
            case RelativeDirection.diagonalBottomLeft:
              didCaptureOnDiagonalBottomLeft = true;

              break;
            case RelativeDirection.diagonalBottomRight:
              didCaptureOnDiagonalBottomRight = true;

              break;
            default:
              break;
          }
        } else {
          switch (relativeDirection) {
            case RelativeDirection.rankLeft:
              if (!didCaptureOnRankLeft) {
                legalMoves.add(move);
                didCaptureOnRankLeft = true;
              }
              break;
            case RelativeDirection.rankRight:
              if (!didCaptureOnRankRight) {
                legalMoves.add(move);
                didCaptureOnRankRight = true;
              }
              break;
            case RelativeDirection.fileTop:
              if (!didCaptureOnFileTop) {
                legalMoves.add(move);
                didCaptureOnFileTop = true;
              }
              break;
            case RelativeDirection.fileBottom:
              if (!didCaptureOnFileBottom) {
                legalMoves.add(move);
                didCaptureOnFileBottom = true;
              }
              break;
            case RelativeDirection.diagonalTopLeft:
              if (!didCaptureOnDiagonalTopLeft) {
                legalMoves.add(move);
                didCaptureOnDiagonalTopLeft = true;
              }
              break;
            case RelativeDirection.diagonalTopRight:
              if (!didCaptureOnDiagonalTopRight) {
                legalMoves.add(move);
                didCaptureOnDiagonalTopRight = true;
              }
              break;
            case RelativeDirection.diagonalBottomLeft:
              if (!didCaptureOnDiagonalBottomLeft) {
                legalMoves.add(move);
                didCaptureOnDiagonalBottomLeft = true;
              }
              break;
            case RelativeDirection.diagonalBottomRight:
              if (!didCaptureOnDiagonalBottomRight) {
                legalMoves.add(move);
                didCaptureOnDiagonalBottomRight = true;
              }
              break;
            default:
              break;
          }
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

  Future<List<Square>> filterMoveThatExposeKingToCheck(
      List<Square> legalMoves, int from, bool fromHandleSquareTapped) async {
    if (fromHandleSquareTapped) {
      PieceType? fromType = from.toPieceType();
      Pieces? fromPiece = from.toPiece();

      // deep copying the list to prevent Concurrent modification of legalMoves
      for (var move in legalMoves.deepCopy()) {
        int moveIndex = ChessBoardModel.getIndexOfSquare(move);
        PieceType? moveType = move.copy().pieceType;
        Pieces? movePiece = move.copy().piece;

        //--------------------

        // emptying the square we are at currently
        await ChessBoardModel.emptySquareAtIndex(from);

        // updating the square at moveIndex
        await ChessBoardModel.updateSquareAtIndex(
          moveIndex,
          fromPiece,
          fromType,
        );

        // here we are checking if the escape square is attacked instead of the tapped square in case the tapped piece is a king, because here we are hypothetically moving a king not another piece
        bool isKingAttacked = await gameStatusController.isKingSquareAttacked(
            attackedKingType: fromType,
            escapeTo: fromPiece == Pieces.king ? moveIndex : null);

        // resetting the hypothetically moved pieces
        await ChessBoardModel.updateSquareAtIndex(from, fromPiece, fromType);
        await ChessBoardModel.updateSquareAtIndex(
            moveIndex, movePiece, moveType);
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

  Future<List<Square>> preventMovingIfCheckRemains(
      {required List<Square> legalMoves, required int to}) async {
    // in this step we place a piece on the legal moves square of the tapped piece and see if the king would still be checked or not.
    List<int> legalMovesIndices = [];

    legalMovesIndices
        .addAll(HelperMethods.instance.squaresToIndices(legalMoves.deepCopy()));

    for (var index in legalMovesIndices) {
      Square currentSquareAtIndex = index.toSquare().copy();
      ChessBoardModel.updateSquareAtIndex(
          index, to.toPiece(), to.toPieceType());

      // here we are checking if the escape square is attacked instead of the tapped square in case the tapped piece is a king, because here we are hypothetically moving a king not another piece
      bool isKingAttacked = await gameStatusController.isKingSquareAttacked(
          escapeTo: to.toPiece() == Pieces.king ? index : null,
          attackedKingType: to.toPieceType());

      if (isKingAttacked) {
        legalMoves.removeWhere((move) =>
            move.file == (index).toSquare().file &&
            move.rank == (index).toSquare().rank);
      }
      // resetting the hypothetically moved piece
      ChessBoardModel.updateSquareAtIndex(
          index, currentSquareAtIndex.piece, currentSquareAtIndex.pieceType);
    }

    return legalMoves;
  }
  //----------------------------------------------------------------------------

  List<Square> getIllegalAndLegalMoves(int from) {
    List<Square> moves = [];
    // Define a map to associate each piece type with its move calculation function
    final Map<Pieces, List<Square> Function()> moveFunctions = {
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
