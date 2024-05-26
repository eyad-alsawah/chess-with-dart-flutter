import 'package:chess/controllers/enums.dart';
import 'package:chess/model/global_state.dart';
import 'package:chess/utils/extensions.dart';

class BasicMovesController {
  // Private constructor
  BasicMovesController._private();

  // Private static instance
  static final BasicMovesController _instance = BasicMovesController._private();

  // Public static method to access the instance
  static BasicMovesController get instance => _instance;
  //----------------------------------------------------------------------------
  List<int> getPawnPieces(int from) {
    Files file = from.file();
    int rank = from.rank();
    PieceType? pieceType = from.type();

    List<int> pawnPieces = [];

    if (pieceType == PieceType.light) {
      //top-right
      (file != Files.h &&
              rank != 8 &&
              ((from + 9).piece() != null ||
                  enPassantController.canCaptureEnPassant(
                    from: from,
                    to: from + 9,
                    relativeDirection: RelativeDirection.diagonalTopRight,
                  )))
          ? pawnPieces.add(from + 9)
          : null;
      //top-left
      (file != Files.a &&
              rank != 8 &&
              ((from + 7).type() != null ||
                  enPassantController.canCaptureEnPassant(
                    from: from,
                    to: from + 7,
                    relativeDirection: RelativeDirection.diagonalTopLeft,
                  )))
          ? pawnPieces.add(from + 7)
          : null;
      //top
      (rank != 8 && (from + 8).type() == null)
          ? (rank == 2 && (from + 16).type() == null)
              ? pawnPieces.addAll([from + 8, from + 16])
              : pawnPieces.add(from + 8)
          : null;
    } else if (pieceType == PieceType.dark) {
      //bottom-right
      (file != Files.h &&
              rank != 1 &&
              ((from - 7).type() != null ||
                  enPassantController.canCaptureEnPassant(
                    from: from,
                    to: from - 7,
                    relativeDirection: RelativeDirection.diagonalBottomRight,
                  )))
          ? pawnPieces.add(from - 7)
          : null;
      //bottom-left
      (file != Files.a &&
              rank != 1 &&
              ((from - 9).type() != null ||
                  enPassantController.canCaptureEnPassant(
                    from: from,
                    to: from - 9,
                    relativeDirection: RelativeDirection.diagonalBottomLeft,
                  )))
          ? pawnPieces.add(from - 9)
          : null;
      //bottom
      (rank != 1 && (from - 8).type() == null)
          ? (rank == 7 && (from - 16).type() == null)
              ? pawnPieces.addAll([from - 8, from - 16])
              : pawnPieces.add(from - 8)
          : null;
    }
    return pawnPieces;
  }

  List<int> getKingPieces(int from, {bool getCastlingPieces = true}) {
    Files file = from.file();
    int rank = from.rank();

    List<int> kingPieces = [];

    // castling:
    getCastlingPieces
        ? kingPieces.addAll(
            castlingController.getCastlingAvailability(pieceType: from.type()!))
        : null;

    //right
    (file != Files.h) ? kingPieces.add(from + 1) : null;
    //left
    (file != Files.a) ? kingPieces.add(from - 1) : null;
    //top-right
    (file != Files.h && rank != 8) ? kingPieces.add(from + 9) : null;
    //top-left
    (file != Files.a && rank != 8) ? kingPieces.add(from + 7) : null;
    //top
    rank != 8 ? kingPieces.add(from + 8) : null;

    //bottom-right
    (file != Files.h && rank != 1) ? kingPieces.add(from - 7) : null;
    //bottom-left
    (file != Files.a && rank != 1) ? kingPieces.add(from - 9) : null;
    //bottom
    rank != 1 ? kingPieces.add(from - 8) : null;

    return kingPieces;
  }

  List<int> getKnightPieces(int from) {
    Files file = from.file();
    int rank = from.rank();

    List<int> knightPieces = [];

    //top-right
    (file != Files.h && rank <= 6) ? knightPieces.add(from + 17) : null;
    //top-left
    (file != Files.a && rank <= 6) ? knightPieces.add(from + 15) : null;
    //----------
    //bottom-right
    (file != Files.h && rank >= 3) ? knightPieces.add(from - 15) : null;
    //bottom-left
    (file != Files.a && rank >= 3) ? knightPieces.add(from - 17) : null;
    //---------
    //right-top
    (file != Files.g && file != Files.h && rank != 8)
        ? knightPieces.add(from + 10)
        : null;
    //right-bottom
    (file != Files.g && file != Files.h && rank != 1)
        ? knightPieces.add(from - 6)
        : null;
    //---------
    //left-top
    (file != Files.b && file != Files.a && rank != 8)
        ? knightPieces.add(from + 6)
        : null;
    //left-bottom
    (file != Files.b && file != Files.a && rank != 1)
        ? knightPieces.add(from - 10)
        : null;

    return knightPieces;
  }

  List<int> getDiagonalPieces(int from) {
    Files file = from.file();
    int rank = from.rank();
    int currentIndex = from;
    List<int> diagonalPieces = [];
    //-----------------------------
    //{RelativeDirection.diagonalTopRight}
    while (currentIndex < 64 &&
        !(currentIndex.file() == Files.a && file != Files.a)) {
      diagonalPieces.add(currentIndex);
      currentIndex = currentIndex + 9;
    }
    currentIndex = from;
    //{RelativeDirection.diagonalBottomLeft}
    while (currentIndex >= 0 &&
        !(currentIndex.file() == Files.h && file != Files.h)) {
      diagonalPieces.add(currentIndex);
      currentIndex = currentIndex - 9;
    }
    currentIndex = from;
    //{RelativeDirection.diagonalTopLeft}
    while (currentIndex < 63 &&
        !(currentIndex.file() == Files.h && file != Files.h)) {
      diagonalPieces.add(currentIndex);
      currentIndex = currentIndex + 7;
    }
    currentIndex = from;
    //{RelativeDirection.diagonalBottomRight}
    while (currentIndex > 0 &&
        !(currentIndex.file() == Files.a && file != Files.a)) {
      diagonalPieces.add(currentIndex);
      currentIndex = currentIndex - 7;
    }
    // remove current piece from the list
    diagonalPieces.removeWhere(
        (element) => element.rank() == rank && element.file() == file);
    return diagonalPieces;
  }

  List<int> getHorizontalPieces(int from) {
    int rank = from.rank();
    Files file = from.file();

    int currentIndex = from;
    List<int> horizontalPieces = [];
    while (currentIndex < rank * 8) {
      horizontalPieces.add(currentIndex);
      currentIndex++;
    }
    currentIndex = from;
    while (currentIndex >= (rank - 1) * 8) {
      horizontalPieces.add(currentIndex);
      currentIndex--;
    }
    // remove current piece from the list
    horizontalPieces.removeWhere(
        (element) => element.rank() == rank && element.file() == file);
    //--------------------------------

    return horizontalPieces;
  }

  List<int> getVerticalPieces(int from) {
    int currentIndex = from;
    List<int> verticalPieces = [];

    while (currentIndex < 64) {
      verticalPieces.add(currentIndex);
      currentIndex += 8;
    }
    currentIndex = from;
    while (currentIndex >= 0) {
      verticalPieces.add(currentIndex);
      currentIndex -= 8;
    }
    // remove current piece from the list
    verticalPieces.removeWhere((element) =>
        element.rank() == from.rank() && element.file() == from.file());
    return verticalPieces;
  }
}
