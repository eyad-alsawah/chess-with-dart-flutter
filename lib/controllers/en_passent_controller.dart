import 'package:chess/controllers/enums.dart';
import 'package:chess/controllers/shared_state.dart';
import 'package:chess/model/global_state.dart';
import 'package:chess/model/chess_board_model.dart';
import 'package:chess/utils/extensions.dart';

class EnPassantController {
  EnPassantController._private();

  // Private static instance
  static final EnPassantController _instance = EnPassantController._private();

// Public static method to access the instance
  static EnPassantController get instance => _instance;
  //-------------------------------------------------------------------------
  static bool handleMove({
    required int from,
    required int to,
  }) {
    // Registers pawns for the ability to be captured by enPassant if moved by two squares from the start position
    _addPawnToEnPassantCapturablePawns(from: from, to: to);

    // if the move resulted in an enPassant capture
    bool didCaptureEnPassant =
        enPassantController.didCaptureEnPassant(from: from, to: to);

    if (didCaptureEnPassant) {
      enPassantController.emptySquareAtCapturedEnPassantPawn(
          from: from, to: to);
    }
    return didCaptureEnPassant;
  }

  static void _addPawnToEnPassantCapturablePawns({
    required int from,
    required int to,
  }) {
    int fromRank = from.rank();
    int toRank = to.rank();
    if (from.piece() == Pieces.pawn &&
        ((fromRank == 2 && toRank == 4) || (fromRank == 7 && toRank == 5))) {
      if (from.type() == PieceType.light) {
        SharedState.instance.enPassantCapturableLightPawnIndex = to;
      } else {
        SharedState.instance.enPassantCapturableDarkPawnIndex = to;
      }
    }
  }

  static void _removePawnFromEnPassantCapturablePawns({
    required PieceType? movedPieceType,
  }) {
    if (movedPieceType == PieceType.light) {
      sharedState.enPassantCapturableDarkPawnIndex = null;
    } else if (movedPieceType == PieceType.dark) {
      sharedState.enPassantCapturableLightPawnIndex = null;
    } else {
      print(
          "this condition will only be reached if player tapped on empty square in selection mode which shouldn't happen because in handleTap we are checking if we pressed on a highlighted index in selection mode");
    }
  }

  bool didCaptureEnPassant({required int from, required int to}) {
    PieceType? movedPieceType = from.type();
    bool didMoveToEmptySquareOnDifferentFile =
        from.file() != to.file() && to.piece() == null;
    bool didMovePawn = from.piece() == Pieces.pawn;
    bool didCaptureEnPassent =
        didMovePawn && didMoveToEmptySquareOnDifferentFile;
    _removePawnFromEnPassantCapturablePawns(movedPieceType: movedPieceType);
    return didCaptureEnPassent;
  }

  bool canCaptureEnPassant({
    required int from,
    required int to,
    required RelativeDirection relativeDirection,
  }) {
    bool canCaptureEnPassant = false;
    int? indexToCheck = from.type() == PieceType.light
        ? sharedState.enPassantCapturableDarkPawnIndex
        : sharedState.enPassantCapturableLightPawnIndex;

    if ((from.type() == PieceType.light && from.rank() == 5) ||
        (from.type() == PieceType.dark && from.rank() == 4)) {
      if (relativeDirection == RelativeDirection.diagonalTopLeft ||
          relativeDirection == RelativeDirection.diagonalBottomLeft) {
        canCaptureEnPassant =
            indexToCheck != null && from > indexToCheck && (to).piece() == null;
      } else {
        canCaptureEnPassant =
            indexToCheck != null && from < indexToCheck && (to).piece() == null;
      }
    }

    return canCaptureEnPassant;
  }

  void emptySquareAtCapturedEnPassantPawn(
      {required int from, required int to}) {
    int capturedPawnIndex =
        from + (to.file().index > from.file().index ? 1 : -1);
    ChessBoardModel.emptySquareAtIndex(capturedPawnIndex);
  }
}
