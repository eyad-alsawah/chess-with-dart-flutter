import 'package:chess/controllers/enums.dart';
import 'package:chess/controllers/helper_methods.dart';
import 'package:chess/model/chess_board_model.dart';
import 'package:chess/model/global_state.dart';

class PromotionController {
  // Private constructor
  PromotionController._private();

  // Private static instance
  static final PromotionController _instance = PromotionController._private();

  // Public static method to access the instance
  static PromotionController get instance => _instance;
  //----------------------------------------------------------------------------
  static Future<Pieces?> handleMove(
      {required int from, required int to}) async {
    if (_shouldPawnBePromoted(from: from, to: to)) {
      return await callbacks
          .onSelectPromotionType(sharedState.playingTurn == PlayingTurn.light
              ? PlayingTurn.dark
              : PlayingTurn.light)
          .then((selectedPromotionType) {
        ChessBoardModel.updateSquareAtIndex(
          to,
          selectedPromotionType,
          sharedState.playingTurn == PlayingTurn.light
              ? PieceType.light
              : PieceType.dark,
        );
        return selectedPromotionType;
      });
    }
    return null;
  }

  static bool _shouldPawnBePromoted({required int from, required int to}) {
    return from.toPiece() == Pieces.pawn &&
        (to.toRank() == 1 || to.toRank() == 8);
  }
}
