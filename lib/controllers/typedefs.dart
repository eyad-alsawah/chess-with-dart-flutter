import 'package:chess/controllers/enums.dart';

typedef OnVictory = void Function(VictoryType victoryType);
typedef OnDraw = void Function(DrawType drawType);
typedef OnPlayingTurnChanged = void Function(PlayingTurn playingTurn);
typedef OnPieceSelected = void Function(
    List<int> highlightedLegalMovesIndices, int selectedPieceIndex);
typedef OnCastling = void Function(int movedRookIndex);
typedef OnPieceMoved = void Function(int from, int to);
typedef OnCapture = void Function();
typedef OnError = void Function(Object? error, String errorString);
typedef OnPawnPromoted = void Function(
    int promotedPieceIndex, Pieces promotedTo);
typedef OnSelectPromotionType = Future<Pieces> Function(
    PlayingTurn playingTurn);
typedef OnEnPassant = void Function(int capturedPawnIndex);
typedef PlaySound = void Function(SoundType soundType);
typedef UpdateView = void Function();
typedef OnCheck = void Function(int checkedKingIndex);
