import 'package:chess/controllers/enums.dart';
import 'package:chess/model/global_state.dart';

import 'package:chess/model/model.dart';
import 'package:chess/model/square.dart';

class EnPassantController {
  EnPassantController._private();

  // Private static instance
  static final EnPassantController _instance = EnPassantController._private();

  // Public static method to access the instance
  static EnPassantController get instance => _instance;
  //----------------------------------------------------------------------------

  void addPawnToEnPassantCapturablePawns(
      {required int fromRank,
      required int toRank,
      required Pieces? piece,
      required int movedToIndex,
      required PieceType? pawnType}) {
    if (piece == Pieces.pawn &&
        ((fromRank == 2 && toRank == 4) || (fromRank == 7 && toRank == 5))) {
      if (pawnType == PieceType.light) {
        sharedState.enPassantCapturableLightPawnIndex = movedToIndex;
      } else {
        sharedState.enPassantCapturableDarkPawnIndex = movedToIndex;
      }
    }
  }

  void _removePawnFromEnPassantCapturablePawns({
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

  bool didCaptureEnPassant({
    required bool didMovePawn,
    required bool didMoveToEmptySquareOnDifferentFile,
    required PieceType? movedPieceType,
  }) {
    bool didCaptureEnPassent =
        didMovePawn && didMoveToEmptySquareOnDifferentFile;
    _removePawnFromEnPassantCapturablePawns(movedPieceType: movedPieceType);
    return didCaptureEnPassent;
  }

  bool canCaptureEnPassant({
    required int fromIndex,
    required int toIndex,
    required int fromRank,
    required PieceType selectedPawnType,
    required RelativeDirection relativeDirection,
  }) {
    bool canCaptureEnPassant = false;
    int? indexToCheck = selectedPawnType == PieceType.light
        ? sharedState.enPassantCapturableDarkPawnIndex
        : sharedState.enPassantCapturableLightPawnIndex;

    if ((selectedPawnType == PieceType.light && fromRank == 5) ||
        (selectedPawnType == PieceType.dark && fromRank == 4)) {
      if (relativeDirection == RelativeDirection.diagonalTopLeft ||
          relativeDirection == RelativeDirection.diagonalBottomLeft) {
        canCaptureEnPassant = indexToCheck != null &&
            fromIndex > indexToCheck &&
            chessBoard[toIndex].piece == null;
      } else {
        canCaptureEnPassant = indexToCheck != null &&
            fromIndex < indexToCheck &&
            chessBoard[toIndex].piece == null;
      }
    }

    return canCaptureEnPassant;
  }

  void updateBoardAfterEnPassant(Files tappedSquareFile,
      Files selectedPieceFile, Square emptyEnPassantCapturedPawnSquare) {
    chessBoard[sharedState.selectedPieceIndex! +
            (tappedSquareFile.index > selectedPieceFile.index ? 1 : -1)] =
        emptyEnPassantCapturedPawnSquare;
    callbacks.onEnPassant(sharedState.selectedPieceIndex! +
        (tappedSquareFile.index > selectedPieceFile.index ? 1 : -1));
  }
}
