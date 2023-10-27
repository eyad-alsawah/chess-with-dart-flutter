import 'enums.dart';
import 'game_controller.dart';

class SharedState {
  // Private constructor
  SharedState._private();

  // Private static instance
  static final SharedState _instance = SharedState._private();

  // Public static method to access the instance
  static SharedState get instance => _instance;

  List<int> legalMovesIndices = [];
  int? selectedPieceIndex;
  Square? selectedPiece;
  PlayingTurn playingTurn = PlayingTurn.white;
  bool isKingInCheck = false;

  int? enPassantCapturableLightPawnIndex;
  int? enPassantCapturableDarkPawnIndex;

  bool inMoveSelectionMode = true;
  bool lockFurtherInteractions = false;

  bool didLightKingMove = false;
  bool didDarkKingMove = false;
  bool didLightKingSideRookMove = false;
  bool didLightQueenSideRookMove = false;
  bool didDarkKingSideRookMove = false;
  bool didDarkQueenSideRookMove = false;
}
