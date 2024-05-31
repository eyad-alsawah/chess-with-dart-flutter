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
      SharedState.instance.enPassantTargetSquare = to.toCoordinates();
    } else {
      SharedState.instance.enPassantTargetSquare = '-';
    }
  }

  bool didCaptureEnPassant({required int from, required int to}) {
    bool didMoveToEmptySquareOnDifferentFile =
        from.file() != to.file() && to.piece() == null;
    bool didMovePawn = from.piece() == Pieces.pawn;
    bool didCaptureEnPassent =
        didMovePawn && didMoveToEmptySquareOnDifferentFile;
    return didCaptureEnPassent;
  }

  bool canCaptureEnPassant({
    required int from,
    required int to,
    required RelativeDirection relativeDirection,
  }) {
    if(from.piece() !=Pieces.pawn) {
      return false;
    }
    bool canCaptureEnPassant = false;
    int? indexToCheck = SharedState.instance.enPassantTargetSquare != '-'
        ? SharedState.instance.enPassantTargetSquare.fromCoordinates()
        : null;

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
