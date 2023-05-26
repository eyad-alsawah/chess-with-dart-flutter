import 'dart:async';

void main() async {
  Chess chess = Chess.fromPosition(
    initialPosition: "initialPosition",
    onVictory: (victoryType) {},
    onDraw: (drawType) {},
    onPieceSelected: (highlightedLegalMovesIndices, selectedPieceIndex) {},
    onCastling: (castlingType, playingTurn) {},
    onPlayingTurnChanged: (playingTurn) {},
    onPieceMoved: (from, to) {},
    onError: (error, errorString) {},
  );
  chess.start();
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
      required this.onCastling})
      : assert(_isValidFen(fenString: initialPosition),
            'initialPosition must be a valid FEN String');
  //------------------------------
  start() {
    // whiteTimer = Timer(const Duration(seconds: 15), () {
    //   ("white time runned out");
    // });
    // blackTimer = Timer(const Duration(seconds: 4), () {
    //   onGameStatusChanged("black time runned out");
    // });
  }

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

  Future<GameStatus> handleSquareTapped({required int tappedSquareIndex}) {
    return Future(
      () => GameStatus(
          highlightedLegalMoves: [],
          chessBoard: [],
          gameOutcome: null,
          playingTurn: PlayingTurn.white,
          selectedPieceIndex: 1,
          gameStatusString: 'White Won !!!',
          canCastleKingSide: false,
          canCastleQueenSide: false),
    );
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
