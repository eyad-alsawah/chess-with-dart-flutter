import 'package:chess/controllers/enums.dart';
import 'package:chess/model/global_state.dart';
import 'package:chess/model/chess_board_model.dart';
import 'package:chess/model/square.dart';

class BasicMovesController {
  // Private constructor
  BasicMovesController._private();

  // Private static instance
  static final BasicMovesController _instance = BasicMovesController._private();

  // Public static method to access the instance
  static BasicMovesController get instance => _instance;
  //----------------------------------------------------------------------------
  List<Square> getPawnPieces({required int rank, required Files file}) {
    Square currentPiece =
        ChessBoardModel.getSquareAtFileAndRank(file: file, rank: rank);
    int currentIndex = ChessBoardModel.getIndexOfSquare(currentPiece);

    List<Square> pawnPieces = [];

    if (currentPiece.pieceType == PieceType.light) {
      //top-right
      (file != Files.h &&
              rank != 8 &&
              ((ChessBoardModel.getSquareAtIndex(currentIndex + 9)).pieceType !=
                      null ||
                  enPassantController.canCaptureEnPassant(
                    fromRank: rank,
                    fromIndex: currentIndex,
                    toIndex: currentIndex + 9,
                    selectedPawnType: PieceType.light,
                    relativeDirection: RelativeDirection.diagonalTopRight,
                  )))
          ? pawnPieces.add(ChessBoardModel.getSquareAtIndex(currentIndex + 9))
          : null;
      //top-left
      (file != Files.a &&
              rank != 8 &&
              ((ChessBoardModel.getSquareAtIndex(currentIndex + 7)).pieceType !=
                      null ||
                  enPassantController.canCaptureEnPassant(
                    fromRank: rank,
                    fromIndex: currentIndex,
                    toIndex: currentIndex + 7,
                    selectedPawnType: PieceType.light,
                    relativeDirection: RelativeDirection.diagonalTopLeft,
                  )))
          ? pawnPieces.add(ChessBoardModel.getSquareAtIndex(currentIndex + 7))
          : null;
      //top
      (rank != 8 &&
              (ChessBoardModel.getSquareAtIndex(currentIndex + 8)).pieceType ==
                  null)
          ? (rank == 2 &&
                  (ChessBoardModel.getSquareAtIndex(currentIndex + 16))
                          .pieceType ==
                      null)
              ? pawnPieces.addAll([
                  ChessBoardModel.getSquareAtIndex(currentIndex + 8),
                  ChessBoardModel.getSquareAtIndex(currentIndex + 16)
                ])
              : pawnPieces
                  .add(ChessBoardModel.getSquareAtIndex(currentIndex + 8))
          : null;
    } else if (currentPiece.pieceType == PieceType.dark) {
      //bottom-right
      (file != Files.h &&
              rank != 1 &&
              ((ChessBoardModel.getSquareAtIndex(currentIndex - 7)).pieceType !=
                      null ||
                  enPassantController.canCaptureEnPassant(
                    fromRank: rank,
                    fromIndex: currentIndex,
                    toIndex: currentIndex - 7,
                    selectedPawnType: PieceType.dark,
                    relativeDirection: RelativeDirection.diagonalBottomRight,
                  )))
          ? pawnPieces.add(ChessBoardModel.getSquareAtIndex(currentIndex - 7))
          : null;
      //bottom-left
      (file != Files.a &&
              rank != 1 &&
              ((ChessBoardModel.getSquareAtIndex(currentIndex - 9)).pieceType !=
                      null ||
                  enPassantController.canCaptureEnPassant(
                    fromRank: rank,
                    fromIndex: currentIndex,
                    toIndex: currentIndex - 9,
                    selectedPawnType: PieceType.dark,
                    relativeDirection: RelativeDirection.diagonalBottomLeft,
                  )))
          ? pawnPieces.add(ChessBoardModel.getSquareAtIndex(currentIndex - 9))
          : null;
      //bottom
      (rank != 1 &&
              (ChessBoardModel.getSquareAtIndex(currentIndex - 8)).pieceType ==
                  null)
          ? (rank == 7 &&
                  (ChessBoardModel.getSquareAtIndex(currentIndex - 16))
                          .pieceType ==
                      null)
              ? pawnPieces.addAll([
                  ChessBoardModel.getSquareAtIndex(currentIndex - 8),
                  ChessBoardModel.getSquareAtIndex(currentIndex - 16)
                ])
              : pawnPieces
                  .add(ChessBoardModel.getSquareAtIndex(currentIndex - 8))
          : null;
    }
    return pawnPieces;
  }

  List<Square> getKingPieces(
      {required int rank, required Files file, bool getCastlingPieces = true}) {
    Square currentPiece =
        ChessBoardModel.getSquareAtFileAndRank(file: file, rank: rank);
    int index = ChessBoardModel.getIndexOfSquare(currentPiece);
    int currentIndex = index;

    List<Square> kingPieces = [];

    // castling:
    getCastlingPieces
        ? kingPieces.addAll(castlingController.getCastlingAvailability(
            pieceType: currentPiece.pieceType!))
        : null;

    //right
    (file != Files.h)
        ? kingPieces.add(ChessBoardModel.getSquareAtIndex(currentIndex + 1))
        : null;
    //left
    (file != Files.a)
        ? kingPieces.add(ChessBoardModel.getSquareAtIndex(currentIndex - 1))
        : null;
    //top-right
    (file != Files.h && rank != 8)
        ? kingPieces.add(ChessBoardModel.getSquareAtIndex(currentIndex + 9))
        : null;
    //top-left
    (file != Files.a && rank != 8)
        ? kingPieces.add(ChessBoardModel.getSquareAtIndex(currentIndex + 7))
        : null;
    //top
    rank != 8
        ? kingPieces.add(ChessBoardModel.getSquareAtIndex(currentIndex + 8))
        : null;

    //bottom-right
    (file != Files.h && rank != 1)
        ? kingPieces.add(ChessBoardModel.getSquareAtIndex(currentIndex - 7))
        : null;
    //bottom-left
    (file != Files.a && rank != 1)
        ? kingPieces.add(ChessBoardModel.getSquareAtIndex(currentIndex - 9))
        : null;
    //bottom
    rank != 1
        ? kingPieces.add(ChessBoardModel.getSquareAtIndex(currentIndex - 8))
        : null;

    return kingPieces;
  }

  List<Square> getKnightPieces({required int rank, required Files file}) {
    Square currentPiece =
        ChessBoardModel.getSquareAtFileAndRank(file: file, rank: rank);
    int index = ChessBoardModel.getIndexOfSquare(currentPiece);
    int currentIndex = index;

    List<Square> knightPieces = [];

    //top-right
    (file != Files.h && rank <= 6)
        ? knightPieces.add(ChessBoardModel.getSquareAtIndex(currentIndex + 17))
        : null;
    //top-left
    (file != Files.a && rank <= 6)
        ? knightPieces.add(ChessBoardModel.getSquareAtIndex(currentIndex + 15))
        : null;
    //----------
    //bottom-right
    (file != Files.h && rank >= 3)
        ? knightPieces.add(ChessBoardModel.getSquareAtIndex(currentIndex - 15))
        : null;
    //bottom-left
    (file != Files.a && rank >= 3)
        ? knightPieces.add(ChessBoardModel.getSquareAtIndex(currentIndex - 17))
        : null;
    //---------
    //right-top
    (file != Files.g && file != Files.h && rank != 8)
        ? knightPieces.add(ChessBoardModel.getSquareAtIndex(currentIndex + 10))
        : null;
    //right-bottom
    (file != Files.g && file != Files.h && rank != 1)
        ? knightPieces.add(ChessBoardModel.getSquareAtIndex(currentIndex - 6))
        : null;
    //---------
    //left-top
    (file != Files.b && file != Files.a && rank != 8)
        ? knightPieces.add(ChessBoardModel.getSquareAtIndex(currentIndex + 6))
        : null;
    //left-bottom
    (file != Files.b && file != Files.a && rank != 1)
        ? knightPieces.add(ChessBoardModel.getSquareAtIndex(currentIndex - 10))
        : null;

    return knightPieces;
  }

  List<Square> getDiagonalPieces({required int rank, required Files file}) {
    Square currentPiece =
        ChessBoardModel.getSquareAtFileAndRank(file: file, rank: rank);
    int index = ChessBoardModel.getIndexOfSquare(currentPiece);
    int currentIndex = index;
    List<Square> diagonalPieces = [];
    //-----------------------------
    //{RelativeDirection.diagonalTopRight}
    while (currentIndex < 64 &&
        !((ChessBoardModel.getSquareAtIndex(currentIndex)).file == Files.a &&
            file != Files.a)) {
      diagonalPieces.add(ChessBoardModel.getSquareAtIndex(currentIndex));
      currentIndex = currentIndex + 9;
    }
    currentIndex = index;
    //{RelativeDirection.diagonalBottomLeft}
    while (currentIndex >= 0 &&
        !((ChessBoardModel.getSquareAtIndex(currentIndex)).file == Files.h &&
            file != Files.h)) {
      diagonalPieces.add(ChessBoardModel.getSquareAtIndex(currentIndex));
      currentIndex = currentIndex - 9;
    }
    currentIndex = index;
    //{RelativeDirection.diagonalTopLeft}
    while (currentIndex < 63 &&
        !((ChessBoardModel.getSquareAtIndex(currentIndex)).file == Files.h &&
            file != Files.h)) {
      diagonalPieces.add(ChessBoardModel.getSquareAtIndex(currentIndex));
      currentIndex = currentIndex + 7;
    }
    currentIndex = index;
    //{RelativeDirection.diagonalBottomRight}
    while (currentIndex > 0 &&
        !((ChessBoardModel.getSquareAtIndex(currentIndex)).file == Files.a &&
            file != Files.a)) {
      diagonalPieces.add(ChessBoardModel.getSquareAtIndex(currentIndex));
      currentIndex = currentIndex - 7;
    }
    // remove current piece from the list
    diagonalPieces
        .removeWhere((element) => element.rank == rank && element.file == file);
    return diagonalPieces;
  }

  List<Square> getHorizontalPieces({required int rank, required Files file}) {
    Square currentPiece =
        ChessBoardModel.getSquareAtFileAndRank(file: file, rank: rank);
    int index = ChessBoardModel.getIndexOfSquare(currentPiece);
    int currentIndex = index;
    List<Square> horizontalPieces = [];
    while (currentIndex < rank * 8) {
      horizontalPieces.add(ChessBoardModel.getSquareAtIndex(currentIndex));
      currentIndex++;
    }
    currentIndex = index;
    while (currentIndex >= (rank - 1) * 8) {
      horizontalPieces.add(ChessBoardModel.getSquareAtIndex(currentIndex));
      currentIndex--;
    }
    // remove current piece from the list
    horizontalPieces
        .removeWhere((element) => element.rank == rank && element.file == file);
    //--------------------------------

    return horizontalPieces;
  }

  List<Square> getVerticalPieces({required int rank, required Files file}) {
    Square currentPiece =
        ChessBoardModel.getSquareAtFileAndRank(file: file, rank: rank);
    int index = ChessBoardModel.getIndexOfSquare(currentPiece);
    int currentIndex = index;
    List<Square> verticalPieces = [];

    while (currentIndex < 64) {
      verticalPieces.add(ChessBoardModel.getSquareAtIndex(currentIndex));
      currentIndex += 8;
    }
    currentIndex = index;
    while (currentIndex >= 0) {
      verticalPieces.add(ChessBoardModel.getSquareAtIndex(currentIndex));
      currentIndex -= 8;
    }
    // remove current piece from the list
    verticalPieces
        .removeWhere((element) => element.rank == rank && element.file == file);
    return verticalPieces;
  }
}
