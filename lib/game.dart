Future<Map<String, dynamic>> handleSquareTapped(
    {required int tappedSquareIndex}) {
  return Future.value({});
}

Future<GameStatus> handleTap({required int tappedSquareIndex}) {
  return Future.value(
      GameStatus([], [], GameOutcome.checkmate, PlayingTurn.black, 1));
}

//---------------------------------------
class Chess {
  /// current PlayingTurn can be known from the initialPosition parameter, but an optional PlayingTurn can be provided using playAs paremeter
  Chess.fromPosition({required String initialPosition, PlayingTurn? playAs})
      : assert(_isValidFen(fenString: initialPosition),
            'initialPosition must be a valid FEN String');

  start() {}

  pause() {}

  resume() {}

  offerDraw() {}

  resign() {}

  toggleLegalMovesHighlight() {}

  quit() {}
}

bool _isValidFen({required fenString}) {
  return true;
}

//----------------------------------------
class GameStatus {
  List<int> highlightedLegalMoves;
  List<Map<String, dynamic>> chessBoard;
  GameOutcome gameOutcome;
  PlayingTurn playingTurn;
  int selectedIndex;

  GameStatus(this.highlightedLegalMoves, this.chessBoard, this.gameOutcome,
      this.playingTurn, this.selectedIndex);
}

enum GameOutcome {
  checkmate,
  draw,
  resignation,
}

enum PlayingTurn { white, black }
//----------------------------------