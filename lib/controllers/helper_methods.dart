import 'package:chess/controllers/enums.dart';
import 'package:chess/model/global_state.dart';
import 'package:chess/model/chess_board_model.dart';
import 'package:chess/model/square.dart';

extension ToSquare on int {
  Square toSquare() {
    return ChessBoardModel.chessBoard.elementAt(this).copy();
  }
}

extension ToPiece on int {
  Pieces? toPiece() {
    return toSquare().piece;
  }
}

extension ToPieceType on int {
  PieceType? toPieceType() {
    return toSquare().pieceType;
  }
}

extension ToOppositeType on PieceType {
  PieceType? toOppositeType() {
    return this == PieceType.light ? PieceType.dark : PieceType.light;
  }
}

extension ToFile on int {
  Files toFile() {
    return Files.values[this % 8];
  }
}

extension ToPlayingTurn on PieceType {
  PlayingTurn toPlayingTurn() {
    return this == PieceType.light ? PlayingTurn.light : PlayingTurn.dark;
  }
}

extension ToRank on int {
  int toRank() {
    return (this ~/ 8) + 1;
  }
}

class HelperMethods {
  // Private constructor
  HelperMethods._private();

  // Private static instance
  static final HelperMethods _instance = HelperMethods._private();

  // Public static method to access the instance
  static HelperMethods get instance => _instance;
  //----------------------------------------------------------------------------

  //----------------------------------------------------------------------------
  bool isInMoveSelectionMode(
      {required int index,
      required PlayingTurn playingTurn,
      required List<int> legalMovesIndices}) {
    PieceType? tappedSquareType = (index).toPieceType();
    bool tappedOnAnEmptySquare = tappedSquareType == null;
    bool tappedOnSquareOfSameType =
        tappedSquareType == playingTurn.toPieceType();
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
  RelativeDirection getRelativeDirection({required int to, required int from}) {
    int currentSquareRank = from.toRank();
    int targetSquareRank = to.toRank();
    Files currentSquareFile = from.toFile();
    Files targetSquareFile = to.toFile();
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
