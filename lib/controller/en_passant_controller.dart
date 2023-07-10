import 'package:chess/model/square.dart';
import 'package:chess/utils/enums.dart';
import 'package:chess/controller/chess_controller.dart';

import 'package:chess/model/model.dart';

class EnPassant{
  static int? _enPassantCapturableLightPawnIndex;
  static int? _enPassantCapturableDarkPawnIndex;

  void addPawnToEnPassantCapturablePawns(
      {required int fromRank,
        required int toRank,
        required Pieces? piece,
        required int movedToIndex,
        required PieceType? pawnType}) {
    if (piece == Pieces.pawn &&
        ((fromRank == 2 && toRank == 4) || (fromRank == 7 && toRank == 5))) {
      if (pawnType == PieceType.light) {
        _enPassantCapturableLightPawnIndex = movedToIndex;
      } else {
        _enPassantCapturableDarkPawnIndex = movedToIndex;
      }
    }
  }

  void removePawnFromEnPassantCapturablePawns({
    required PieceType? movedPieceType,
  }) {
    if (movedPieceType == PieceType.light) {
      _enPassantCapturableDarkPawnIndex = null;
    } else if (movedPieceType == PieceType.dark) {
      _enPassantCapturableLightPawnIndex = null;
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
    removePawnFromEnPassantCapturablePawns(movedPieceType: movedPieceType);
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
        ? _enPassantCapturableDarkPawnIndex
        : _enPassantCapturableLightPawnIndex;

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
    chessBoard[ChessController.selectedPieceIndex! +
        (tappedSquareFile.index > selectedPieceFile.index ? 1 : -1)] =
        emptyEnPassantCapturedPawnSquare;
  }

}
