import 'package:chess/controllers/basic_moves_controller.dart';
import 'package:chess/controllers/callbacks.dart';
import 'package:chess/controllers/castling_controller.dart';
import 'package:chess/controllers/en_passent_controller.dart';
import 'package:chess/controllers/game_status_controller.dart';
import 'package:chess/controllers/helper_methods.dart';
import 'package:chess/controllers/legal_moves_controller.dart';
import 'package:chess/controllers/promotion_controller.dart';
import 'package:chess/controllers/shared_state.dart';

SharedState sharedState = SharedState.instance;
Callbacks callbacks = Callbacks.instance;
EnPassantController enPassantController = EnPassantController.instance;
LegalMovesController legalMovesController = LegalMovesController.instance;
CastlingController castlingController = CastlingController.instance;
BasicMovesController basicMovesController = BasicMovesController.instance;
HelperMethods helperMethods = HelperMethods.instance;
GameStatusController gameStatusController = GameStatusController.instance;
PromotionController promotionController = PromotionController.instance;
