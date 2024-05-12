import 'package:chess/controllers/enums.dart';
import 'package:chess/model/global_state.dart';
import 'package:chess/model/chess_board_model.dart';
import 'package:chess/model/square.dart';

class HelperMethods {
  // Private constructor
  HelperMethods._private();

  // Private static instance
  static final HelperMethods _instance = HelperMethods._private();

  // Public static method to access the instance
  static HelperMethods get instance => _instance;
  //----------------------------------------------------------------------------

  Files getFileNameFromIndex({required int index}) {
    return Files.values[index % 8];
  }

  int getRankNameFromIndex({required int index}) {
    return (index ~/ 8) + 1;
  }

  //----------------------------------------------------------------------------

  //----------------------------------------------------------------------------
  bool isInMoveSelectionMode(
      {required int tappedSquareIndex,
      required PlayingTurn playingTurn,
      required List<int> legalMovesIndices}) {
    bool inMoveSelectionMode =
        // pressing on an empty square or on a square occupied by an openent piece that is not in the legal moves should not change the value to false
        ((ChessBoardModel.getSquareAtIndex(tappedSquareIndex).pieceType ==
                        null ||
                    (ChessBoardModel.getSquareAtIndex(tappedSquareIndex)
                                .pieceType ==
                            PieceType.light &&
                        sharedState.playingTurn != PlayingTurn.white) ||
                    (ChessBoardModel.getSquareAtIndex(tappedSquareIndex)
                                .pieceType ==
                            PieceType.dark &&
                        sharedState.playingTurn != PlayingTurn.black)) &&
                !legalMovesIndices.contains(tappedSquareIndex)) ||
            (ChessBoardModel.getSquareAtIndex(tappedSquareIndex).pieceType ==
                    PieceType.light &&
                sharedState.playingTurn == PlayingTurn.white) ||
            (ChessBoardModel.getSquareAtIndex(tappedSquareIndex).pieceType ==
                    PieceType.dark &&
                sharedState.playingTurn == PlayingTurn.black);
    return inMoveSelectionMode;
  }

  bool shouldClearLegalMovesIndices(
      {required PieceType? selectedPieceType,
      required PlayingTurn playingTurn}) {
    bool shouldClearLegalMovesIndices =
        ((sharedState.selectedPiece?.pieceType == PieceType.light &&
                sharedState.playingTurn != PlayingTurn.white) ||
            (sharedState.selectedPiece?.pieceType == PieceType.dark &&
                sharedState.playingTurn != PlayingTurn.black));
    return shouldClearLegalMovesIndices;
  }

  List<int> squaresToIndices(List<Square> squares) {
    List<int> indices = [];
    for (var move in squares) {
      int squareIndex = ChessBoardModel.getIndexOfSquare(move);
      if (squareIndex >= 0 && squareIndex <= 63) {
        indices.add(squareIndex);
      }
    }
    return indices;
  }

  //----------------------------------------------------------------------------
  RelativeDirection getRelativeDirection(
      {required Square targetSquare, required Square currentSquare}) {
    int currentSquareRank = currentSquare.rank;
    int targetSquareRank = targetSquare.rank;
    Files currentSquareFile = currentSquare.file;
    Files targetSquareFile = targetSquare.file;
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
