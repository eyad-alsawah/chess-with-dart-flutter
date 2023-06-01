import 'dart:async';
import 'dart:io';

void main() async {
  Chess chess = Chess.fromPosition(
    initialPosition: "initialPosition",
    onVictory: (victoryType) {},
    onDraw: (drawType) {},
    onPieceSelected: (highlightedLegalMovesIndices, selectedPieceIndex) {
      print("selectedPieceIndex: $selectedPieceIndex");
      print("highlightedLegalMovesIndices:$highlightedLegalMovesIndices");
      print("//---------------------------------------");
    },
    onCastling: (castlingType, playingTurn) {},
    onPlayingTurnChanged: (playingTurn) {},
    onPieceMoved: (from, to) {},
    onError: (error, errorString) {},
    onPawnPromoted: (promotedPieceIndex, promotedTo) {},
    onSelectPromotionType: (playingTurn) async {
      return Pieces.queen;
    },
  );
}

//---------------------------------------

class Chess {
  final void Function(VictoryType victoryType) onVictory;
  final void Function(DrawType drawType) onDraw;
  final void Function(PlayingTurn playingTurn) onPlayingTurnChanged;
  final void Function(
          List<int> highlightedLegalMovesIndices, int selectedPieceIndex)
      onPieceSelected;
  final void Function(CastlingType castlingType, PlayingTurn playingTurn)
      onCastling;
  final void Function(int from, int to) onPieceMoved;
  final void Function(Error error, String errorString) onError;
  final void Function(int promotedPieceIndex, Pieces promotedTo) onPawnPromoted;
  final Future<Pieces> Function(PlayingTurn playingTurn) onSelectPromotionType;
//-------------------------------------------
  List<Square> chessBoard = [
    // -------------------------------First Rank------------------
    Square(
        file: Files.a, rank: 1, piece: Pieces.rook, pieceType: PieceType.light),
    Square(
        file: Files.b,
        rank: 1,
        piece: Pieces.knight,
        pieceType: PieceType.light),
    Square(
        file: Files.c,
        rank: 1,
        piece: Pieces.bishop,
        pieceType: PieceType.light),
    Square(
        file: Files.d,
        rank: 1,
        piece: Pieces.queen,
        pieceType: PieceType.light),
    Square(
        file: Files.e, rank: 1, piece: Pieces.king, pieceType: PieceType.light),
    Square(
        file: Files.f,
        rank: 1,
        piece: Pieces.bishop,
        pieceType: PieceType.light),
    Square(
        file: Files.g,
        rank: 1,
        piece: Pieces.knight,
        pieceType: PieceType.light),
    Square(
        file: Files.h, rank: 1, piece: Pieces.rook, pieceType: PieceType.light),
    // -------------------------------Second Rank------------------
    Square(
        file: Files.a, rank: 2, piece: Pieces.pawn, pieceType: PieceType.light),
    Square(
        file: Files.b, rank: 2, piece: Pieces.pawn, pieceType: PieceType.light),
    Square(
        file: Files.c, rank: 2, piece: Pieces.pawn, pieceType: PieceType.light),
    Square(
        file: Files.d, rank: 2, piece: Pieces.pawn, pieceType: PieceType.light),
    Square(
        file: Files.e, rank: 2, piece: Pieces.pawn, pieceType: PieceType.light),
    Square(
        file: Files.f, rank: 2, piece: Pieces.pawn, pieceType: PieceType.light),
    Square(
        file: Files.g, rank: 2, piece: Pieces.pawn, pieceType: PieceType.light),
    Square(
        file: Files.h, rank: 2, piece: Pieces.pawn, pieceType: PieceType.light),
    // -------------------------------Third Rank------------------
    Square(file: Files.a, rank: 3, piece: null, pieceType: null),
    Square(file: Files.b, rank: 3, piece: null, pieceType: null),
    Square(file: Files.c, rank: 3, piece: null, pieceType: null),
    Square(file: Files.d, rank: 3, piece: null, pieceType: null),
    Square(file: Files.e, rank: 3, piece: null, pieceType: null),
    Square(file: Files.f, rank: 3, piece: null, pieceType: null),
    Square(file: Files.g, rank: 3, piece: null, pieceType: null),
    Square(file: Files.h, rank: 3, piece: null, pieceType: null),
    // -------------------------------Fourth Rank------------------
    Square(file: Files.a, rank: 4, piece: null, pieceType: null),
    Square(file: Files.b, rank: 4, piece: null, pieceType: null),
    Square(file: Files.c, rank: 4, piece: null, pieceType: null),
    Square(file: Files.d, rank: 4, piece: null, pieceType: null),
    Square(file: Files.e, rank: 4, piece: null, pieceType: null),
    Square(file: Files.f, rank: 4, piece: null, pieceType: null),
    Square(file: Files.g, rank: 4, piece: null, pieceType: null),
    Square(file: Files.h, rank: 4, piece: null, pieceType: null),
    // -------------------------------Fifth Rank------------------
    Square(file: Files.a, rank: 5, piece: null, pieceType: null),
    Square(file: Files.b, rank: 5, piece: null, pieceType: null),
    Square(file: Files.c, rank: 5, piece: null, pieceType: null),
    Square(file: Files.d, rank: 5, piece: null, pieceType: null),
    Square(file: Files.e, rank: 5, piece: null, pieceType: null),
    Square(file: Files.f, rank: 5, piece: null, pieceType: null),
    Square(file: Files.g, rank: 5, piece: null, pieceType: null),
    Square(file: Files.h, rank: 5, piece: null, pieceType: null),
    // -------------------------------Sixth Rank------------------
    Square(file: Files.a, rank: 6, piece: null, pieceType: null),
    Square(file: Files.b, rank: 6, piece: null, pieceType: null),
    Square(file: Files.c, rank: 6, piece: null, pieceType: null),
    Square(file: Files.d, rank: 6, piece: null, pieceType: null),
    Square(file: Files.e, rank: 6, piece: null, pieceType: null),
    Square(file: Files.f, rank: 6, piece: null, pieceType: null),
    Square(file: Files.g, rank: 6, piece: null, pieceType: null),
    Square(file: Files.h, rank: 6, piece: null, pieceType: null),
    // -------------------------------Seventh Rank------------------
    Square(
        file: Files.a, rank: 7, piece: Pieces.pawn, pieceType: PieceType.dark),
    Square(
        file: Files.b, rank: 7, piece: Pieces.pawn, pieceType: PieceType.dark),
    Square(
        file: Files.c, rank: 7, piece: Pieces.pawn, pieceType: PieceType.dark),
    Square(
        file: Files.d, rank: 7, piece: Pieces.pawn, pieceType: PieceType.dark),
    Square(
        file: Files.e, rank: 7, piece: Pieces.pawn, pieceType: PieceType.dark),
    Square(
        file: Files.f, rank: 7, piece: Pieces.pawn, pieceType: PieceType.dark),
    Square(
        file: Files.g, rank: 7, piece: Pieces.pawn, pieceType: PieceType.dark),
    Square(
        file: Files.h, rank: 7, piece: Pieces.pawn, pieceType: PieceType.dark),
    // -------------------------------Eigth Rank------------------
    Square(
        file: Files.a, rank: 8, piece: Pieces.rook, pieceType: PieceType.dark),
    Square(
        file: Files.b,
        rank: 8,
        piece: Pieces.knight,
        pieceType: PieceType.dark),
    Square(
        file: Files.c,
        rank: 8,
        piece: Pieces.bishop,
        pieceType: PieceType.dark),
    Square(
        file: Files.d, rank: 8, piece: Pieces.queen, pieceType: PieceType.dark),
    Square(
        file: Files.e, rank: 8, piece: Pieces.king, pieceType: PieceType.dark),
    Square(
        file: Files.f,
        rank: 8,
        piece: Pieces.bishop,
        pieceType: PieceType.dark),
    Square(
        file: Files.g,
        rank: 8,
        piece: Pieces.knight,
        pieceType: PieceType.dark),
    Square(
        file: Files.h, rank: 8, piece: Pieces.rook, pieceType: PieceType.dark),
  ];
  late Timer whiteTimer;
  late Timer blackTimer;
  bool inMoveSelectionMode = true;

  /// current PlayingTurn can be known from the initialPosition parameter, but an optional PlayingTurn can be provided using playAs paremeter
  Chess.fromPosition(
      {required String initialPosition,
      PlayingTurn? playAs,
      required this.onVictory,
      required this.onDraw,
      required this.onPieceSelected,
      required this.onPlayingTurnChanged,
      required this.onPieceMoved,
      required this.onError,
      required this.onCastling,
      required this.onPawnPromoted,
      required this.onSelectPromotionType})
      : assert(_isValidFen(fenString: initialPosition),
            'initialPosition must be a valid FEN String');
  //------------------------------
  start() {}

  pause() {}
  resume() {}
  offerDraw() {}
  resign() {}
  //------------------------------
  toggleLegalMovesHighlight() {}

  highlightLegalMovesForAllPieces() {}
  //--------------------------------
  exportGame() {}
  saveGame() {}
  loadGame() {}
  //-------------------------------
  requestTimerPause() {}
  //-----------------------------------
  getCurrentPlayingTurn() {}
  offerUndoMove() {}

  //---------------------------------
  List<int> legalMovesIndices = [];
  int? selectedPieceIndex;
  Square? selectedPiece;
  // initial playingTurn is set to white, (todo: change this if [fromPosition] constructor was called)
  PlayingTurn playingTurn = PlayingTurn.white;
  handleSquareTapped({required int tappedSquareIndex}) async {
    Files tappedSquareFile = getFileNameFromIndex(index: tappedSquareIndex);
    int tappedSquareRank = getRankNameFromIndex(index: tappedSquareIndex);
    if (inMoveSelectionMode) {
      selectedPieceIndex = tappedSquareIndex;
      selectedPiece = chessBoard[tappedSquareIndex];
      List<Square> legalAndIllegalMoves = getIllegalAndLegalMoves(
          rank: tappedSquareRank, file: tappedSquareFile);
      List<Square> legalMovesOnly = getLegalMovesOnly(
          file: tappedSquareFile,
          rank: tappedSquareRank,
          legalAndIllegalMoves: legalAndIllegalMoves);
      legalMovesIndices =
          getLegalMovesIndices(legalMovesSquares: legalMovesOnly);
      // preventing player who's turn is not his to play by emptying the legalMovesIndices list
      ((selectedPiece?.pieceType == PieceType.light &&
                  playingTurn != PlayingTurn.white) ||
              (selectedPiece?.pieceType == PieceType.dark &&
                  playingTurn != PlayingTurn.black))
          ? legalMovesIndices.clear()
          : null;
      onPieceSelected(legalMovesIndices, tappedSquareIndex);
      inMoveSelectionMode = legalMovesIndices.isEmpty;
      return;
    }
    // checking nullability only for safely using null check operator
    else if (legalMovesIndices.contains(tappedSquareIndex) &&
        selectedPiece != null &&
        selectedPieceIndex != null) {
      bool shouldPromotePawn = selectedPiece!.piece == Pieces.pawn &&
          (tappedSquareRank == 1 || tappedSquareRank == 8);
      // pawn will be promoted to queen by default
      Pieces promotedPawn = Pieces.queen;
      Files selectedPieceFile =
          getFileNameFromIndex(index: selectedPieceIndex!);
      int selectedPieceRank = getRankNameFromIndex(index: selectedPieceIndex!);

      playingTurn = playingTurn == PlayingTurn.white
          ? PlayingTurn.black
          : PlayingTurn.white;
      onPlayingTurnChanged(playingTurn);
      onPieceMoved(selectedPieceIndex!, tappedSquareIndex);
      shouldPromotePawn
          ? await onSelectPromotionType(playingTurn == PlayingTurn.white
                  ? PlayingTurn.black
                  : PlayingTurn.white)
              .then((selectedPromotionType) {
              promotedPawn = selectedPromotionType;
              onPawnPromoted(tappedSquareIndex, selectedPromotionType);
            })
          : null;
      // empty square that will replace the square on which the piece that we will move is at
      Square emptySquareAtSelectedPieceIndex = Square(
          file: selectedPieceFile,
          rank: selectedPieceRank,
          piece: null,
          pieceType: null);
      Square newSquareAtTappedIndex = Square(
        file: tappedSquareFile,
        rank: tappedSquareRank,
        piece: shouldPromotePawn ? promotedPawn : selectedPiece?.piece,
        pieceType: selectedPiece?.pieceType,
      );
      chessBoard[tappedSquareIndex] = newSquareAtTappedIndex;
      chessBoard[selectedPieceIndex!] = emptySquareAtSelectedPieceIndex;
    }
    onPieceSelected([], tappedSquareIndex);
    inMoveSelectionMode = true;
    legalMovesIndices.clear();
  }

  // ---------------------------------------------------------------------------
  Files getFileNameFromIndex({required int index}) {
    List<Files> files = [
      Files.a,
      Files.b,
      Files.c,
      Files.d,
      Files.e,
      Files.f,
      Files.g,
      Files.h
    ];
    index++;
    int rank = (index / 8).ceil();
    Files file = files[index - 8 * (rank - 1) - 1];
    return file;
  }

  int getRankNameFromIndex({required int index}) {
    index++;
    int rank = (index / 8).ceil();
    return rank;
  }

  List<Square> getIllegalAndLegalMoves(
      {required int rank, required Files file}) {
    Square tappedPiece = chessBoard
        .firstWhere((element) => element.rank == rank && element.file == file);
    List<Square> moves = [];
    switch (tappedPiece.piece) {
      case Pieces.rook:
        moves = [
          ...getHorizontalPieces(rank: rank, file: file),
          ...getVerticalPieces(rank: rank, file: file)
        ];
        break;
      case Pieces.knight:
        moves = getKnightPieces(rank: rank, file: file);
        break;
      case Pieces.bishop:
        moves = getDiagonalPieces(rank: rank, file: file);
        break;

      case Pieces.queen:
        moves = [
          ...getHorizontalPieces(rank: rank, file: file),
          ...getVerticalPieces(rank: rank, file: file),
          ...getDiagonalPieces(rank: rank, file: file)
        ];
        break;
      case Pieces.king:
        moves = getKingPieces(rank: rank, file: file);
        break;
      case Pieces.pawn:
        moves = getPawnPieces(rank: rank, file: file);
        break;
      default:
        moves.clear();
    }
    return moves;
  }

  List<Square> getKnightPieces({required int rank, required Files file}) {
    Square currentPiece = chessBoard
        .firstWhere((element) => element.rank == rank && element.file == file);
    int index = chessBoard.indexOf(currentPiece);
    int currentIndex = index;

    List<Square> knightPieces = [];

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

  List<Square> getPawnPieces({required int rank, required Files file}) {
    Square currentPiece = chessBoard
        .firstWhere((element) => element.rank == rank && element.file == file);
    int index = chessBoard.indexOf(currentPiece);
    int currentIndex = index;

    List<Square> pawnPieces = [];

    if (currentPiece.pieceType == PieceType.light) {
      //top-right
      (file != Files.h &&
              rank != 8 &&
              chessBoard[currentIndex + 9].pieceType != null)
          ? pawnPieces.add(chessBoard[currentIndex + 9])
          : null;
      //top-left
      (file != Files.a &&
              rank != 8 &&
              chessBoard[currentIndex + 7].pieceType != null)
          ? pawnPieces.add(chessBoard[currentIndex + 7])
          : null;
      //top
      (rank != 8 && chessBoard[currentIndex + 8].pieceType == null)
          ? (rank == 2 && chessBoard[currentIndex + 16].pieceType == null)
              ? pawnPieces.addAll(
                  [chessBoard[currentIndex + 8], chessBoard[currentIndex + 16]])
              : pawnPieces.add(chessBoard[currentIndex + 8])
          : null;
    } else if (currentPiece.pieceType == PieceType.dark) {
      //bottom-right
      (file != Files.h &&
              rank != 1 &&
              chessBoard[currentIndex - 7].pieceType != null)
          ? pawnPieces.add(chessBoard[currentIndex - 7])
          : null;
      //bottom-left
      (file != Files.a &&
              rank != 1 &&
              chessBoard[currentIndex - 9].pieceType != null)
          ? pawnPieces.add(chessBoard[currentIndex - 9])
          : null;
      //bottom
      (rank != 1 && chessBoard[currentIndex - 8].pieceType == null)
          ? (rank == 7 && chessBoard[currentIndex - 16].pieceType == null)
              ? pawnPieces.addAll(
                  [chessBoard[currentIndex - 8], chessBoard[currentIndex - 16]])
              : pawnPieces.add(chessBoard[currentIndex - 8])
          : null;
    }
    return pawnPieces;
  }

  List<Square> getKingPieces({required int rank, required Files file}) {
    Square currentPiece = chessBoard
        .firstWhere((element) => element.rank == rank && element.file == file);
    int index = chessBoard.indexOf(currentPiece);
    int currentIndex = index;

    List<Square> kingPieces = [];

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

  List<Square> getDiagonalPieces({required int rank, required Files file}) {
    Square currentPiece = chessBoard
        .firstWhere((element) => element.rank == rank && element.file == file);
    int index = chessBoard.indexOf(currentPiece);
    int currentIndex = index;
    List<Square> diagonalPieces = [];
    //-----------------------------
    //{RelativeDirection.diagonalTopRight}
    while (currentIndex < 64 &&
        !(chessBoard[currentIndex].file == Files.a && file != Files.a)) {
      diagonalPieces.add(chessBoard[currentIndex]);
      currentIndex = currentIndex + 9;
    }
    currentIndex = index;
    //{RelativeDirection.diagonalBottomLeft}
    while (currentIndex >= 0 &&
        !(chessBoard[currentIndex].file == Files.h && file != Files.h)) {
      diagonalPieces.add(chessBoard[currentIndex]);
      currentIndex = currentIndex - 9;
    }
    currentIndex = index;
    //{RelativeDirection.diagonalTopLeft}
    while (currentIndex < 63 &&
        !(chessBoard[currentIndex].file == Files.h && file != Files.h)) {
      diagonalPieces.add(chessBoard[currentIndex]);
      currentIndex = currentIndex + 7;
    }
    currentIndex = index;
    //{RelativeDirection.diagonalBottomRight}
    while (currentIndex > 0 &&
        !(chessBoard[currentIndex].file == Files.a && file != Files.a)) {
      diagonalPieces.add(chessBoard[currentIndex]);
      currentIndex = currentIndex - 7;
    }
    // remove current piece from the list
    diagonalPieces
        .removeWhere((element) => element.rank == rank && element.file == file);
    return diagonalPieces;
  }

//-------------------
  List<Square> getHorizontalPieces({required int rank, required Files file}) {
    Square currentPiece = chessBoard
        .firstWhere((element) => element.rank == rank && element.file == file);
    int index = chessBoard.indexOf(currentPiece);
    int currentIndex = index;
    List<Square> horizontalPieces = [];
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
    horizontalPieces
        .removeWhere((element) => element.rank == rank && element.file == file);
    //--------------------------------

    return horizontalPieces;
  }

//----------------------
  List<Square> getVerticalPieces({required int rank, required Files file}) {
    Square currentPiece = chessBoard
        .firstWhere((element) => element.rank == rank && element.file == file);
    int index = chessBoard.indexOf(currentPiece);
    int currentIndex = index;
    List<Square> verticalPieces = [];

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
    verticalPieces
        .removeWhere((element) => element.rank == rank && element.file == file);
    return verticalPieces;
  }

  //------------------------------------------Getting Legal Moves--------------------------
  List<Square> getLegalMovesOnly(
      {required List<Square> legalAndIllegalMoves,
      required Files file,
      required int rank}) {
    List<Square> legalMoves = [];
    Square tappedPiece = chessBoard
        .firstWhere((element) => element.rank == rank && element.file == file);

    bool didCaptureOnRankLeft = false;
    bool didCaptureOnRankRight = false;
    bool didCaptureOnFileTop = false;
    bool didCaptureOnFileBottom = false;
    bool didCaptureOnDiagonalTopLeft = false;
    bool didCaptureOnDiagonalTopRight = false;
    bool didCaptureOnDiagonalBottomLeft = false;
    bool didCaptureOnDiagonalBottomRight = false;

    for (var square in legalAndIllegalMoves) {
      RelativeDirection relativeDirection = getRelativeDirection(
          currentSquare: tappedPiece, targetSquare: square);

      if (tappedPiece.pieceType == null) {
        legalMoves.clear();
      } else if (tappedPiece.piece == Pieces.knight) {
        // treated differently than other pieces due to the way the knight moves
        (square.piece == null || square.pieceType != tappedPiece.pieceType)
            ? legalMoves.add(square)
            : null;
      } else if (square.piece == null) {
        switch (relativeDirection) {
          case RelativeDirection.rankLeft:
            if (!didCaptureOnRankLeft) {
              legalMoves.add(square);
            }
            break;
          case RelativeDirection.rankRight:
            if (!didCaptureOnRankRight) {
              legalMoves.add(square);
            }
            break;
          case RelativeDirection.fileTop:
            if (!didCaptureOnFileTop) {
              legalMoves.add(square);
            }
            break;
          case RelativeDirection.fileBottom:
            if (!didCaptureOnFileBottom) {
              legalMoves.add(square);
            }
            break;
          case RelativeDirection.diagonalTopLeft:
            if (!didCaptureOnDiagonalTopLeft) {
              legalMoves.add(square);
            }
            break;
          case RelativeDirection.diagonalTopRight:
            if (!didCaptureOnDiagonalTopRight) {
              legalMoves.add(square);
            }
            break;
          case RelativeDirection.diagonalBottomLeft:
            if (!didCaptureOnDiagonalBottomLeft) {
              legalMoves.add(square);
            }
            break;
          case RelativeDirection.diagonalBottomRight:
            if (!didCaptureOnDiagonalBottomRight) {
              legalMoves.add(square);
            }
            break;
          default:
            break;
        }
      } else {
        if (square.pieceType == tappedPiece.pieceType) {
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
                legalMoves.add(square);
                didCaptureOnRankLeft = true;
              }
              break;
            case RelativeDirection.rankRight:
              if (!didCaptureOnRankRight) {
                legalMoves.add(square);
                didCaptureOnRankRight = true;
              }
              break;
            case RelativeDirection.fileTop:
              if (!didCaptureOnFileTop) {
                legalMoves.add(square);
                didCaptureOnFileTop = true;
              }
              break;
            case RelativeDirection.fileBottom:
              if (!didCaptureOnFileBottom) {
                legalMoves.add(square);
                didCaptureOnFileBottom = true;
              }
              break;
            case RelativeDirection.diagonalTopLeft:
              if (!didCaptureOnDiagonalTopLeft) {
                legalMoves.add(square);
                didCaptureOnDiagonalTopLeft = true;
              }
              break;
            case RelativeDirection.diagonalTopRight:
              if (!didCaptureOnDiagonalTopRight) {
                legalMoves.add(square);
                didCaptureOnDiagonalTopRight = true;
              }
              break;
            case RelativeDirection.diagonalBottomLeft:
              if (!didCaptureOnDiagonalBottomLeft) {
                legalMoves.add(square);
                didCaptureOnDiagonalBottomLeft = true;
              }
              break;
            case RelativeDirection.diagonalBottomRight:
              if (!didCaptureOnDiagonalBottomRight) {
                legalMoves.add(square);
                didCaptureOnDiagonalBottomRight = true;
              }
              break;
            default:
              break;
          }
        }
      }
    }
    // if (isPinned(
    //     kingType: currentPiece['type'],
    //     pieceToCheck: currentPiece,
    //     possibleSquaresToMoveTo: squaresMovableTo)) {
    //   squaresMovableTo.clear();
    // }

    return legalMoves;
  }
//-------------------------------------

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
      print(
          "reached condition in getRelativeDirection that should not be reached");
    }
    return relativeDirection;
  }

  List<int> getLegalMovesIndices({required List<Square> legalMovesSquares}) {
    List<int> legalMovesIndices = [];
    for (var square in legalMovesSquares) {
      int squareIndex = chessBoard.indexOf(square);
      if (squareIndex >= 0 && squareIndex <= 63) {
        legalMovesIndices.add(squareIndex);
      }
    }
    return legalMovesIndices;
  }
}

class Square {
  Files file;
  int rank;
  Pieces? piece;
  PieceType? pieceType;

  Square({
    required this.file,
    required this.rank,
    required this.piece,
    required this.pieceType,
  });
}

bool _isValidFen({required fenString}) {
  return true;
}

//----------------------------------------
class GameStatus {
  //------------selection mode------------
  final List<int> highlightedLegalMoves;
  final bool canCastleKingSide;
  final bool canCastleQueenSide;
  final int? selectedPieceIndex;
  //-------------------------------

  final List<Map<String, dynamic>> chessBoard;
  final GameOutcome? gameOutcome;
  final String? gameStatusString;
  final PlayingTurn playingTurn;

  GameStatus({
    required this.highlightedLegalMoves,
    required this.chessBoard,
    required this.gameOutcome,
    required this.playingTurn,
    required this.selectedPieceIndex,
    required this.gameStatusString,
    required this.canCastleKingSide,
    required this.canCastleQueenSide,
  });
}

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

enum GameOutcome {
  victory,
  draw,
}

enum VictoryType {
  checkmate,
  timeout,
  resignation,
}

enum DrawType {
  insufficientMaterial,
  stalemate,
  fiftyMoveRule,
  mutualAgreement,
  threeFoldRepetition
}

enum CastlingType { kingSide, queenSide }

enum PlayingTurn { white, black }

enum PieceType { light, dark }

enum Files { a, b, c, d, e, f, g, h }

enum Pieces {
  rook,
  knight,
  bishop,
  queen,
  king,
  pawn,
}
//----------------------------------
/// generic
/// generic
