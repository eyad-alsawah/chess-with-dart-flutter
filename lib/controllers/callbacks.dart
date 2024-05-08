import 'package:chess/controllers/typedefs.dart';

class Callbacks {
  // Private constructor
  Callbacks._internal();

  // Private static instance
  static final Callbacks _instance = Callbacks._internal();

  // Public static method to access the instance
  static Callbacks get instance => _instance;
  late OnVictory onVictory;
  late OnDraw onDraw;
  late OnPlayingTurnChanged onPlayingTurnChanged;
  late OnPieceSelected onPieceSelected;
  late OnPieceMoved onPieceMoved;
  late OnError onError;
  late OnSelectPromotionType onSelectPromotionType;
  late PlaySound playSound;
  late UpdateView updateView;
  late OnCapture onCapture;
}
