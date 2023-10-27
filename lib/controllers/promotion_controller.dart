import 'package:chess/controllers/enums.dart';

class PromotionController {
  // Private constructor
  PromotionController._private();

  // Private static instance
  static final PromotionController _instance = PromotionController._private();

  // Public static method to access the instance
  static PromotionController get instance => _instance;
  //----------------------------------------------------------------------------
  bool shouldPawnBePromoted(
      {required Pieces? selectedPiecePiece, required tappedSquareRank}) {
    return selectedPiecePiece == Pieces.pawn &&
        (tappedSquareRank == 1 || tappedSquareRank == 8);
  }
}
