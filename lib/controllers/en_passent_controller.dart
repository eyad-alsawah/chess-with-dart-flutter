import 'package:chess/controllers/enums.dart';
import 'package:chess/controllers/helper_methods.dart';
import 'package:chess/model/global_state.dart';
import 'package:chess/model/chess_board_model.dart';

class EnPassantController {
  EnPassantController._private();

  // Private static instance
  static final EnPassantController _instance = EnPassantController._private();

// Public static method to access the instance
  static EnPassantController get instance => _instance;
  //----------------------------------------------------------------------------
  static int? enPassantCapturableLightPawnIndex;
  static int? enPassantCapturableDarkPawnIndex;
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
    int fromRank = from.toRank();
    int toRank = to.toRank();
    if (from.toPiece() == Pieces.pawn &&
        ((fromRank == 2 && toRank == 4) || (fromRank == 7 && toRank == 5))) {
      if (from.toPieceType() == PieceType.light) {
        enPassantCapturableLightPawnIndex = to;
      } else {
        enPassantCapturableDarkPawnIndex = to;
      }
    }
  }

  static void _removePawnFromEnPassantCapturablePawns({
    required PieceType? movedPieceType,
  }) {
    if (movedPieceType == PieceType.light) {
      enPassantCapturableDarkPawnIndex = null;
    } else if (movedPieceType == PieceType.dark) {
      enPassantCapturableLightPawnIndex = null;
    } else {
      print(
          "this condition will only be reached if player tapped on empty square in selection mode which shouldn't happen because in handleTap we are checking if we pressed on a highlighted index in selection mode");
    }
  }

  bool didCaptureEnPassant({required int from, required int to}) {
    PieceType? movedPieceType = from.toPieceType();
    bool didMoveToEmptySquareOnDifferentFile =
        from.toFile() != to.toFile() && to.toPiece() == null;
    bool didMovePawn = from.toPiece() == Pieces.pawn;
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
    int? indexToCheck = from.toPieceType() == PieceType.light
        ? enPassantCapturableDarkPawnIndex
        : enPassantCapturableLightPawnIndex;

    if ((from.toPieceType() == PieceType.light && from.toRank() == 5) ||
        (from.toPieceType() == PieceType.dark && from.toRank() == 4)) {
      if (relativeDirection == RelativeDirection.diagonalTopLeft ||
          relativeDirection == RelativeDirection.diagonalBottomLeft) {
        canCaptureEnPassant = indexToCheck != null &&
            from > indexToCheck &&
            (to).toPiece() == null;
      } else {
        canCaptureEnPassant = indexToCheck != null &&
            from < indexToCheck &&
            (to).toPiece() == null;
      }
    }

    return canCaptureEnPassant;
  }

  void emptySquareAtCapturedEnPassantPawn(
      {required int from, required int to}) {
    int capturedPawnIndex =
        from + (to.toFile().index > from.toFile().index ? 1 : -1);
    ChessBoardModel.emptySquareAtIndex(capturedPawnIndex);
  }
}
