import '../model/global_state.dart';
import '../utils/extensions.dart';
import 'enums.dart';
import 'shared_state.dart';

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
          .onSelectPromotionType(SharedState.instance.playingTurn);
    }
    return null;
  }

  static bool _shouldPawnBePromoted({required int from, required int to}) {
    return from.piece() == Pieces.pawn && (to.rank() == 1 || to.rank() == 8);
  }
}
