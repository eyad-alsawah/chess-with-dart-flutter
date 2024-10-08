import 'package:chess/controllers/basic_moves_controller.dart';
import 'package:chess/controllers/castling_controller.dart';
import 'package:chess/controllers/enums.dart';
import 'package:chess/controllers/shared_state.dart';
import 'package:chess/model/global_state.dart';
import 'package:chess/model/chess_board_model.dart';

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
            selectedPiece: from.square())) {
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
            from: from,
            legalAndIllegalMoves: legalAndIllegalMoves.deepCopy(),
            fromHandleSquareTapped: fromHandleSquareTapped);

    for (var move in legalAndIllegalMoves) {
      RelativeDirection relativeDirection =
          helperMethods.getRelativeDirection(from: from, to: move);

      bool fromEmptySquare = from.type() == null;
      bool toEmptySquare = move.piece() == null;
      bool toOppositeType = move.type() != from.type();

      if (fromEmptySquare) {
        legalMoves.clear();
      } else if (from.piece() == Pieces.knight) {
        // treated differently than other pieces due to the way the knight moves
        (move.piece() == null || move.type() != from.type())
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

    if (fromHandleSquareTapped) {
      // condition to prevent entering a loop filterMoveThatExposeKingToCheck --> isKingSquareAttacked --> getLegalMovesOnly ---> filterMoveThatExposeKingToCheck ...
      legalMoves =
          await filterMovesThatExposeKingToCheck(legalMoves.deepCopy(), from);
      // todo: explain why this is in the condition, (we don't intersect non king moves with opponent king when called from isKingSquareAttacked)
      legalMoves = await filterMovesThatCauseTwoAdjacentKings(
          legalMoves.deepCopy(), from);
    }

    return legalMoves.deepCopy();
  }

  Future<List<int>> filterMovesThatExposeKingToCheck(
      List<int> legalMoves, int from) async {
    PieceType? fromType = from.type();
    Pieces? fromPiece = from.piece();

    // emptying the square we are at currently
    await ChessBoardModel.emptySquareAtIndex(from);
    for (var move in legalMoves.deepCopy()) {
      PieceType? moveType = move.type();
      Pieces? movePiece = move.piece();
      // updating the square at move
      await ChessBoardModel.updateSquareAtIndex(
        move,
        fromPiece,
        fromType,
      );

      // here we are checking if the escape square is attacked instead of the tapped square in case the tapped piece is a king, because here we are hypothetically moving a king not another piece
      bool isKingAttacked = await gameStatusController.isKingSquareAttacked(
          kingTypeToCheck: fromType);

      await ChessBoardModel.updateSquareAtIndex(move, movePiece, moveType);

      isKingAttacked ? legalMoves.remove(move) : null;
    }
    // resetting the hypothetically moved pieces
    await ChessBoardModel.updateSquareAtIndex(from, fromPiece, fromType);
    return legalMoves;
  }

  Future<List<int>> filterMovesThatCauseTwoAdjacentKings(
      List<int> legalMoves, int from) async {
    if (from.piece() != Pieces.king) {
      // return the list unmodified in case we are not trying to move a king.
      return legalMoves;
    }
    int opponentKingIndex = ChessBoardModel.getIndexWherePieceAndPieceTypeMatch(
        Pieces.king, from.type()?.oppositeType());
    List<int> opponentKingMoves =
        BasicMovesController.instance.getKingPieces(opponentKingIndex);

    legalMoves.removeWhere((e) => opponentKingMoves.contains(e));
    return legalMoves;
  }

  Future<bool> areTwoKingsAdjacent() async {
    int anyKingIndex = ChessBoardModel.getIndexWherePieceAndPieceTypeMatch(
        Pieces.king, PieceType.light);
    List<int> opponentKingMoves =
        BasicMovesController.instance.getKingPieces(anyKingIndex);

    return opponentKingMoves.any((move) {
      return move.piece() == Pieces.king;
    });
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
    moves = moveFunctions[from.piece()]?.call() ?? [];

    return moves;
  }
}
