import 'dart:math';

List<Map<String, dynamic>> chessBoard = [
  // -----------------------------------rank 1----------------------------
  {
    "file": Files.a,
    "rank": 1,
    "piece": Pieces.rook,
    "type": PieceType.light,
  },
  {"file": Files.b, "rank": 1, "piece": Pieces.knight, "type": PieceType.light},
  {"file": Files.c, "rank": 1, "piece": Pieces.bishop, "type": PieceType.light},
  {"file": Files.d, "rank": 1, "piece": Pieces.queen, "type": PieceType.light},
  {"file": Files.e, "rank": 1, "piece": Pieces.king, "type": PieceType.light},
  {"file": Files.f, "rank": 1, "piece": Pieces.bishop, "type": PieceType.light},
  {"file": Files.g, "rank": 1, "piece": Pieces.knight, "type": PieceType.light},
  {"file": Files.h, "rank": 1, "piece": Pieces.rook, "type": PieceType.light},
  //--------------------------- rank 2----------------------------------------
  {"file": Files.a, "rank": 2, "piece": Pieces.pawn, "type": PieceType.light},
  {"file": Files.b, "rank": 2, "piece": Pieces.pawn, "type": PieceType.light},
  {"file": Files.c, "rank": 2, "piece": Pieces.pawn, "type": PieceType.light},
  {"file": Files.d, "rank": 2, "piece": Pieces.pawn, "type": PieceType.light},
  {"file": Files.e, "rank": 2, "piece": Pieces.pawn, "type": PieceType.light},
  {"file": Files.f, "rank": 2, "piece": Pieces.pawn, "type": PieceType.light},
  {"file": Files.g, "rank": 2, "piece": Pieces.pawn, "type": PieceType.light},
  {"file": Files.h, "rank": 2, "piece": Pieces.pawn, "type": PieceType.light},
  //------------------------------rank 3---------------------------------------
  {"file": Files.a, "rank": 3, "piece": null, "type": null},
  {"file": Files.b, "rank": 3, "piece": null, "type": null},
  {"file": Files.c, "rank": 3, "piece": null, "type": null},
  {"file": Files.d, "rank": 3, "piece": null, "type": null},
  {"file": Files.e, "rank": 3, "piece": null, "type": null},
  {"file": Files.f, "rank": 3, "piece": null, "type": null},
  {"file": Files.g, "rank": 3, "piece": null, "type": null},
  {"file": Files.h, "rank": 3, "piece": null, "type": null},
  //-----------------------------rank 4------------------------------------
  {"file": Files.a, "rank": 4, "piece": null, "type": null},
  {"file": Files.b, "rank": 4, "piece": null, "type": null},
  {"file": Files.c, "rank": 4, "piece": null, "type": null},
  {"file": Files.d, "rank": 4, "piece": null, "type": null},
  {"file": Files.e, "rank": 4, "piece": null, "type": null},
  {"file": Files.f, "rank": 4, "piece": null, "type": null},
  {"file": Files.g, "rank": 4, "piece": null, "type": null},
  {"file": Files.h, "rank": 4, "piece": null, "type": null},
  //-----------------------------------rank 5----------------------------------
  {"file": Files.a, "rank": 5, "piece": null, "type": null},
  {"file": Files.b, "rank": 5, "piece": null, "type": null},
  {"file": Files.c, "rank": 5, "piece": null, "type": null},
  {"file": Files.d, "rank": 5, "piece": null, "type": null},
  {"file": Files.e, "rank": 5, "piece": null, "type": null},
  {"file": Files.f, "rank": 5, "piece": null, "type": null},
  {"file": Files.g, "rank": 5, "piece": null, "type": null},
  {"file": Files.h, "rank": 5, "piece": null, "type": null},
  //-----------------------------------rank 6----------------------------------
  {"file": Files.a, "rank": 6, "piece": null, "type": null},
  {"file": Files.b, "rank": 6, "piece": null, "type": null},
  {"file": Files.c, "rank": 6, "piece": null, "type": null},
  {"file": Files.d, "rank": 6, "piece": null, "type": null},
  {"file": Files.e, "rank": 6, "piece": null, "type": null},
  {"file": Files.f, "rank": 6, "piece": null, "type": null},
  {"file": Files.g, "rank": 6, "piece": null, "type": null},
  {"file": Files.h, "rank": 6, "piece": null, "type": null},
  //-----------------------------------rank 7----------------------------------
  {"file": Files.a, "rank": 7, "piece": Pieces.pawn, "type": PieceType.dark},
  {"file": Files.b, "rank": 7, "piece": Pieces.pawn, "type": PieceType.dark},
  {"file": Files.c, "rank": 7, "piece": Pieces.pawn, "type": PieceType.dark},
  {"file": Files.d, "rank": 7, "piece": Pieces.pawn, "type": PieceType.dark},
  {"file": Files.e, "rank": 7, "piece": Pieces.pawn, "type": PieceType.dark},
  {"file": Files.f, "rank": 7, "piece": Pieces.pawn, "type": PieceType.dark},
  {"file": Files.g, "rank": 7, "piece": Pieces.pawn, "type": PieceType.dark},
  {"file": Files.h, "rank": 7, "piece": Pieces.pawn, "type": PieceType.dark},
  //------------------------------------rank 8----------------------------------
  {"file": Files.a, "rank": 8, "piece": Pieces.rook, "type": PieceType.dark},
  {"file": Files.b, "rank": 8, "piece": Pieces.knight, "type": PieceType.dark},
  {"file": Files.c, "rank": 8, "piece": Pieces.bishop, "type": PieceType.dark},
  {"file": Files.d, "rank": 8, "piece": Pieces.queen, "type": PieceType.dark},
  {"file": Files.e, "rank": 8, "piece": Pieces.king, "type": PieceType.dark},
  {"file": Files.f, "rank": 8, "piece": Pieces.bishop, "type": PieceType.dark},
  {"file": Files.g, "rank": 8, "piece": Pieces.knight, "type": PieceType.dark},
  {"file": Files.h, "rank": 8, "piece": Pieces.rook, "type": PieceType.dark}
];

bool getAllPieces = false;

enum Pieces {
  rook,
  knight,
  bishop,
  queen,
  king,
  pawn,
}

enum PieceType { light, dark }

enum Files { a, b, c, d, e, f, g, h }

enum RelativeDirection {
  rankLeft,
  rankRight,
  fileTop,
  fileBottom,
  diagonalTopLeft,
  diagonalTopRight,
  diagonalBottomLeft,
  diagonalBottomRight,
  undefined
}

RelativeDirection getRelativeDirection(
    {required Map<String, dynamic> targetSquare,
    required Map<String, dynamic> currentSquare}) {
  int currentSquareRank = currentSquare['rank'];
  int targetSquareRank = targetSquare['rank'];
  Files currentSquareFile = currentSquare['file'];
  Files targetSquareFile = targetSquare['file'];
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
    print(
        "reached condition in getRelativeDirection that should not be reached");
  }
  return relativeDirection;
}

//----------------------Get Pieces---------------------------

/// generic
List<Map<String, dynamic>> getPieces({required int rank, required Files file}) {
  Map<String, dynamic> currentPiece = chessBoard.firstWhere(
      (element) => element['rank'] == rank && element['file'] == file);
  List<Map<String, dynamic>> pieces = [];
  switch (currentPiece['piece']) {
    case Pieces.rook:
      pieces = [
        ...getHorizontalPieces(rank: rank, file: file),
        ...getVerticalPieces(rank: rank, file: file)
      ];
      break;
    case Pieces.knight:
      pieces = getKnightPieces(rank: rank, file: file);
      break;
    case Pieces.bishop:
      pieces = getDiagonalPieces(rank: rank, file: file);
      break;

    case Pieces.queen:
      pieces = [
        ...getHorizontalPieces(rank: rank, file: file),
        ...getVerticalPieces(rank: rank, file: file),
        ...getDiagonalPieces(rank: rank, file: file)
      ];
      break;
    case Pieces.king:
      pieces = getKingPieces(rank: rank, file: file);
      break;
    case Pieces.pawn:
      pieces = getPawnPieces(rank: rank, file: file);
      break;
    default:
      pieces.clear();
  }
  return pieces;
}

List<Map<String, dynamic>> getKnightPieces(
    {required int rank, required Files file}) {
  Map<String, dynamic> currentPiece = chessBoard.firstWhere(
      (element) => element['rank'] == rank && element['file'] == file);
  int index = chessBoard.indexOf(currentPiece);
  int currentIndex = index;

  List<Map<String, dynamic>> knightPieces = [];

  //top-right
  (file != Files.h && rank <= 6)
      ? knightPieces.add(chessBoard[currentIndex + 17])
      : null;
  //top-left
  (file != Files.a && rank <= 6)
      ? knightPieces.add(chessBoard[currentIndex + 15])
      : null;
  //----------
  //bottom-right
  (file != Files.h && rank >= 3)
      ? knightPieces.add(chessBoard[currentIndex - 15])
      : null;
  //bottom-left
  (file != Files.a && rank >= 3)
      ? knightPieces.add(chessBoard[currentIndex - 17])
      : null;
  //---------
  //right-top
  (file != Files.g && file != Files.h && rank != 8)
      ? knightPieces.add(chessBoard[currentIndex + 10])
      : null;
  //right-bottom
  (file != Files.g && file != Files.h && rank != 1)
      ? knightPieces.add(chessBoard[currentIndex - 6])
      : null;
  //---------
  //left-top
  (file != Files.b && file != Files.a && rank != 8)
      ? knightPieces.add(chessBoard[currentIndex + 6])
      : null;
  //left-bottom
  (file != Files.b && file != Files.a && rank != 1)
      ? knightPieces.add(chessBoard[currentIndex - 10])
      : null;

  return knightPieces;
}

List<Map<String, dynamic>> getPawnPieces(
    {required int rank, required Files file}) {
  Map<String, dynamic> currentPiece = chessBoard.firstWhere(
      (element) => element['rank'] == rank && element['file'] == file);
  int index = chessBoard.indexOf(currentPiece);
  int currentIndex = index;

  List<Map<String, dynamic>> pawnPieces = [];

  if (currentPiece['type'] == PieceType.light) {
    //top-right
    (file != Files.h && rank != 8)
        ? pawnPieces.add(chessBoard[currentIndex + 9])
        : null;
    //top-left
    (file != Files.a && rank != 8)
        ? pawnPieces.add(chessBoard[currentIndex + 7])
        : null;
    //top
    rank != 8 ? pawnPieces.add(chessBoard[currentIndex + 8]) : null;
  } else if (currentPiece['type'] == PieceType.dark) {
    //bottom-right
    (file != Files.h && rank != 1)
        ? pawnPieces.add(chessBoard[currentIndex - 7])
        : null;
    //bottom-left
    (file != Files.a && rank != 1)
        ? pawnPieces.add(chessBoard[currentIndex - 9])
        : null;
    //bottom
    rank != 1 ? pawnPieces.add(chessBoard[currentIndex - 8]) : null;
  }

  return pawnPieces;
}

List<Map<String, dynamic>> getKingPieces(
    {required int rank, required Files file}) {
  Map<String, dynamic> currentPiece = chessBoard.firstWhere(
      (element) => element['rank'] == rank && element['file'] == file);
  int index = chessBoard.indexOf(currentPiece);
  int currentIndex = index;

  List<Map<String, dynamic>> kingPieces = [];

  //right
  (file != Files.h) ? kingPieces.add(chessBoard[currentIndex + 1]) : null;
  //left
  (file != Files.a) ? kingPieces.add(chessBoard[currentIndex - 1]) : null;
  //top-right
  (file != Files.h && rank != 8)
      ? kingPieces.add(chessBoard[currentIndex + 9])
      : null;
  //top-left
  (file != Files.a && rank != 8)
      ? kingPieces.add(chessBoard[currentIndex + 7])
      : null;
  //top
  rank != 8 ? kingPieces.add(chessBoard[currentIndex + 8]) : null;

  //bottom-right
  (file != Files.h && rank != 1)
      ? kingPieces.add(chessBoard[currentIndex - 7])
      : null;
  //bottom-left
  (file != Files.a && rank != 1)
      ? kingPieces.add(chessBoard[currentIndex - 9])
      : null;
  //bottom
  rank != 1 ? kingPieces.add(chessBoard[currentIndex - 8]) : null;

  return kingPieces;
}

List<Map<String, dynamic>> getDiagonalPieces(
    {required int rank, required Files file}) {
  Map<String, dynamic> currentPiece = chessBoard.firstWhere(
      (element) => element['rank'] == rank && element['file'] == file);
  int index = chessBoard.indexOf(currentPiece);
  int currentIndex = index;
  List<Map<String, dynamic>> diagonalPieces = [];
  //-----------------------------
  //{RelativeDirection.diagonalTopRight}
  while (currentIndex < 64 &&
      !(chessBoard[currentIndex]['file'] == Files.a && file != Files.a)) {
    diagonalPieces.add(chessBoard[currentIndex]);
    currentIndex = currentIndex + 9;
  }
  currentIndex = index;
  //{RelativeDirection.diagonalBottomLeft}
  while (currentIndex >= 0 &&
      !(chessBoard[currentIndex]['file'] == Files.h && file != Files.h)) {
    diagonalPieces.add(chessBoard[currentIndex]);
    currentIndex = currentIndex - 9;
  }
  currentIndex = index;
  //{RelativeDirection.diagonalTopLeft}
  while (currentIndex < 63 &&
      !(chessBoard[currentIndex]['file'] == Files.h && file != Files.h)) {
    diagonalPieces.add(chessBoard[currentIndex]);
    currentIndex = currentIndex + 7;
  }
  currentIndex = index;
  //{RelativeDirection.diagonalBottomRight}
  while (currentIndex > 0 &&
      !(chessBoard[currentIndex]['file'] == Files.a && file != Files.a)) {
    diagonalPieces.add(chessBoard[currentIndex]);
    currentIndex = currentIndex - 7;
  }
  // remove current piece from the list
  diagonalPieces.removeWhere(
      (element) => element['rank'] == rank && element['file'] == file);
  return diagonalPieces;
}

//-------------------
List<Map<String, dynamic>> getHorizontalPieces(
    {required int rank, required Files file}) {
  Map<String, dynamic> currentPiece = chessBoard.firstWhere(
      (element) => element['rank'] == rank && element['file'] == file);
  int index = chessBoard.indexOf(currentPiece);
  int currentIndex = index;
  List<Map<String, dynamic>> horizontalPieces = [];
  while (currentIndex < rank * 8) {
    horizontalPieces.add(chessBoard[currentIndex]);
    currentIndex++;
  }
  currentIndex = index;
  while (currentIndex >= (rank - 1) * 8) {
    horizontalPieces.add(chessBoard[currentIndex]);
    currentIndex--;
  }
  // remove current piece from the list
  horizontalPieces.removeWhere(
      (element) => element['rank'] == rank && element['file'] == file);
  //--------------------------------

  return horizontalPieces;
}

//----------------------
List<Map<String, dynamic>> getVerticalPieces(
    {required int rank, required Files file}) {
  Map<String, dynamic> currentPiece = chessBoard.firstWhere(
      (element) => element['rank'] == rank && element['file'] == file);
  int index = chessBoard.indexOf(currentPiece);
  int currentIndex = index;
  List<Map<String, dynamic>> verticalPieces = [];

  while (currentIndex < 64) {
    verticalPieces.add(chessBoard[currentIndex]);
    currentIndex += 8;
  }
  currentIndex = index;
  while (currentIndex >= 0) {
    verticalPieces.add(chessBoard[currentIndex]);
    currentIndex -= 8;
  }
  // remove current piece from the list
  verticalPieces.removeWhere(
      (element) => element['rank'] == rank && element['file'] == file);
  return verticalPieces;
}

//---------------------------Check if piece can move-------
List<Map<String, dynamic>> squaresMovableTo(
    {required List<Map<String, dynamic>> possibleSquaresToMoveTo,
    required Files file,
    required int rank}) {
  List<Map<String, dynamic>> squaresMovableTo = [];
  Map<String, dynamic> currentPiece = chessBoard.firstWhere(
      (element) => element['rank'] == rank && element['file'] == file);

  bool didCaptureOnRankLeft = false;
  bool didCaptureOnRankRight = false;
  bool didCaptureOnFileTop = false;
  bool didCaptureOnFileBottom = false;
  bool didCaptureOnDiagonalTopLeft = false;
  bool didCaptureOnDiagonalTopRight = false;
  bool didCaptureOnDiagonalBottomLeft = false;
  bool didCaptureOnDiagonalBottomRight = false;

  for (var square in possibleSquaresToMoveTo) {
    RelativeDirection relativeDirection =
        getRelativeDirection(currentSquare: currentPiece, targetSquare: square);

    if (currentPiece['type'] == null) {
      squaresMovableTo.clear();
    } else if (currentPiece['piece'] == Pieces.knight) {
      (square['piece'] == null || square['type'] != currentPiece['type'])
          ? squaresMovableTo.add(square)
          : null;
    } else if (square['piece'] == null) {
      switch (relativeDirection) {
        case RelativeDirection.rankLeft:
          if (!didCaptureOnRankLeft) {
            squaresMovableTo.add(square);
          }
          break;
        case RelativeDirection.rankRight:
          if (!didCaptureOnRankRight) {
            squaresMovableTo.add(square);
          }
          break;
        case RelativeDirection.fileTop:
          if (!didCaptureOnFileTop) {
            squaresMovableTo.add(square);
          }
          break;
        case RelativeDirection.fileBottom:
          if (!didCaptureOnFileBottom) {
            squaresMovableTo.add(square);
          }
          break;
        case RelativeDirection.diagonalTopLeft:
          if (!didCaptureOnDiagonalTopLeft) {
            squaresMovableTo.add(square);
          }
          break;
        case RelativeDirection.diagonalTopRight:
          if (!didCaptureOnDiagonalTopRight) {
            squaresMovableTo.add(square);
          }
          break;
        case RelativeDirection.diagonalBottomLeft:
          if (!didCaptureOnDiagonalBottomLeft) {
            squaresMovableTo.add(square);
          }
          break;
        case RelativeDirection.diagonalBottomRight:
          if (!didCaptureOnDiagonalBottomRight) {
            squaresMovableTo.add(square);
          }
          break;
        default:
          break;
      }
    } else {
      if (square['type'] == currentPiece['type']) {
        switch (relativeDirection) {
          case RelativeDirection.rankLeft:
            didCaptureOnRankLeft = true;
            break;
          case RelativeDirection.rankRight:
            didCaptureOnRankRight = true;

            break;
          case RelativeDirection.fileTop:
            didCaptureOnFileTop = true;

            break;
          case RelativeDirection.fileBottom:
            didCaptureOnFileBottom = true;

            break;
          case RelativeDirection.diagonalTopLeft:
            didCaptureOnDiagonalTopLeft = true;

            break;
          case RelativeDirection.diagonalTopRight:
            didCaptureOnDiagonalTopRight = true;

            break;
          case RelativeDirection.diagonalBottomLeft:
            didCaptureOnDiagonalBottomLeft = true;

            break;
          case RelativeDirection.diagonalBottomRight:
            didCaptureOnDiagonalBottomRight = true;

            break;
          default:
            break;
        }
      } else {
        switch (relativeDirection) {
          case RelativeDirection.rankLeft:
            if (!didCaptureOnRankLeft) {
              squaresMovableTo.add(square);
              didCaptureOnRankLeft = true;
            }
            break;
          case RelativeDirection.rankRight:
            if (!didCaptureOnRankRight) {
              squaresMovableTo.add(square);
              didCaptureOnRankRight = true;
            }
            break;
          case RelativeDirection.fileTop:
            if (!didCaptureOnFileTop) {
              squaresMovableTo.add(square);
              didCaptureOnFileTop = true;
            }
            break;
          case RelativeDirection.fileBottom:
            if (!didCaptureOnFileBottom) {
              squaresMovableTo.add(square);
              didCaptureOnFileBottom = true;
            }
            break;
          case RelativeDirection.diagonalTopLeft:
            if (!didCaptureOnDiagonalTopLeft) {
              squaresMovableTo.add(square);
              didCaptureOnDiagonalTopLeft = true;
            }
            break;
          case RelativeDirection.diagonalTopRight:
            if (!didCaptureOnDiagonalTopRight) {
              squaresMovableTo.add(square);
              didCaptureOnDiagonalTopRight = true;
            }
            break;
          case RelativeDirection.diagonalBottomLeft:
            if (!didCaptureOnDiagonalBottomLeft) {
              squaresMovableTo.add(square);
              didCaptureOnDiagonalBottomLeft = true;
            }
            break;
          case RelativeDirection.diagonalBottomRight:
            if (!didCaptureOnDiagonalBottomRight) {
              squaresMovableTo.add(square);
              didCaptureOnDiagonalBottomRight = true;
            }
            break;
          default:
            break;
        }
      }
    }
  }
  if (isPinned(
      kingType: currentPiece['type'],
      pieceToCheck: currentPiece,
      possibleSquaresToMoveTo: squaresMovableTo)) {
    squaresMovableTo.clear();
  }

  return squaresMovableTo;
}

bool isPinned(
    {required PieceType? kingType,
    required List<Map<String, dynamic>> possibleSquaresToMoveTo,
    required Map<String, dynamic> pieceToCheck}) {
  List<Map<String, dynamic>> squaresWhereKingMightGetChecked = [];
  List<Map<String, dynamic>> chessBoardForTesting = chessBoard;
  int pieceToCheckIndex = chessBoard.indexOf(pieceToCheck);

  //we want to move each piece and check if that might get our king to be checked
  for (var possibleSquareToMoveTo in possibleSquaresToMoveTo) {
    isKingChecked(
            pieceType: pieceToCheck['type'],
            squaresToCheckIfCheckingKing: possibleSquaresToMoveTo)
        ? squaresWhereKingMightGetChecked.add(possibleSquareToMoveTo)
        : null;
    print(squaresWhereKingMightGetChecked.length);
  }

  return false;
}

bool isKingChecked(
    {required PieceType pieceType,
    required List<Map<String, dynamic>> squaresToCheckIfCheckingKing}) {
  List<Map<String, dynamic>> piecesCheckingKing = [];
  for (var square in chessBoard) {
    int rank = square['rank'];
    Files file = square['file'];
    PieceType? type = square['type'];
    //if pieceType is light we are checking if light's king is checked by any dark piece on the board
    // this is done by checking if any dark piece on the board can move to light's king square
    if (type != null && type != pieceType) {
      for (var squareToCheck in squaresToCheckIfCheckingKing) {
        if (squareToCheck['type'] != null &&
            squareToCheck['type'] != type &&
            squareToCheck['piece'] == Pieces.king) {
          piecesCheckingKing.add(square);
        }
      }
    }
  }

  print("//----------------------------------");
  return piecesCheckingKing.isNotEmpty;
}

//--------

//     if false:

