import 'package:chess/controllers/enums.dart';
import 'package:chess/model/global_state.dart';
import 'package:chess/model/square.dart';
import 'package:chess/utils/extensions.dart';

class HelperMethods {
  // Private constructor
  HelperMethods._private();

  // Private static instance
  static final HelperMethods _instance = HelperMethods._private();

  // Public static method to access the instance
  static HelperMethods get instance => _instance;
  //----------------------------------------------------------------------------
  bool isInMoveSelectionMode(
      {required int index,
      required PlayingTurn playingTurn,
      required List<int> legalMovesIndices}) {
    PieceType? tappedSquareType = (index).type();
    bool tappedOnAnEmptySquare = tappedSquareType == null;
    bool tappedOnSquareOfSameType = tappedSquareType == playingTurn.type();
    bool tappedOnSquareCanMoveTo = legalMovesIndices.contains(index);
    return ((tappedOnAnEmptySquare || tappedOnSquareOfSameType) &&
        !tappedOnSquareCanMoveTo);
  }

  bool selectedPieceDoesNotMatchCurrentPlayingTurn(
      {required Square? selectedPiece}) {
    bool shouldClearLegalMovesIndices = selectedPiece != null &&
        ((selectedPiece.pieceType == PieceType.light &&
                sharedState.playingTurn != PlayingTurn.light) ||
            (selectedPiece.pieceType == PieceType.dark &&
                sharedState.playingTurn != PlayingTurn.dark));
    return shouldClearLegalMovesIndices;
  }

  //----------------------------------------------------------------------------
  RelativeDirection getRelativeDirection({required int to, required int from}) {
    int currentSquareRank = from.rank();
    int targetSquareRank = to.rank();
    Files currentSquareFile = from.file();
    Files targetSquareFile = to.file();
    RelativeDirection relativeDirection;
    if (targetSquareRank == currentSquareRank) {
      relativeDirection = targetSquareFile.index > currentSquareFile.index
          ? RelativeDirection.rankRight
          : RelativeDirection.rankLeft;
    } else if (targetSquareFile == currentSquareFile) {
      relativeDirection = targetSquareRank > currentSquareRank
          ? RelativeDirection.fileTop
          : RelativeDirection.fileBottom;
    } else if (targetSquareFile.index > currentSquareFile.index) {
      relativeDirection = targetSquareRank > currentSquareRank
          ? RelativeDirection.diagonalTopRight
          : RelativeDirection.diagonalBottomRight;
    } else if (targetSquareFile.index < currentSquareFile.index) {
      relativeDirection = targetSquareRank > currentSquareRank
          ? RelativeDirection.diagonalTopLeft
          : RelativeDirection.diagonalBottomLeft;
    } else {
      relativeDirection = RelativeDirection.undefined;
    }
    return relativeDirection;
  }

  preventFurtherInteractions(bool status) {
    sharedState.lockFurtherInteractions = status;
  }
}
