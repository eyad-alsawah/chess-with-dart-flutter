import 'dart:async';
import 'package:chess/controllers/castling_controller.dart';
import 'package:chess/controllers/en_passent_controller.dart';
import 'package:chess/controllers/enums.dart';
import 'package:chess/controllers/game_status_controller.dart';
import 'package:chess/controllers/promotion_controller.dart';
import 'package:chess/controllers/typedefs.dart';
import 'package:chess/model/global_state.dart';
import 'package:chess/model/chess_board_model.dart';
import 'package:chess/model/square.dart';
import 'package:chess/utils/extensions.dart';
import 'package:chess/utils/fen_parser.dart';

//--------------Main Game Controller-------------------
class ChessController {
  final OnVictory onVictory;
  final OnPlayingTurnChanged onPlayingTurnChanged;
  final OnPieceSelected onPieceSelected;

  final OnError onError;
  final OnSelectPromotionType onSelectPromotionType;
  final PlaySound playSound;
  final UpdateView updateView;
  final OnDraw onDraw;
  final String? fenString;
//-------------------------------------------

  int? from;
  bool inMoveSelectionMode = true;
  //----------------------------------------------------------------------------
  void registerCallbacksListeners() {
    callbacks.onVictory = onVictory;
    callbacks.onPlayingTurnChanged = onPlayingTurnChanged;
    callbacks.onPieceSelected = onPieceSelected;
    callbacks.onError = onError;
    callbacks.onSelectPromotionType = onSelectPromotionType;
    callbacks.playSound = playSound;
    callbacks.updateView = updateView;
    callbacks.onDraw = onDraw;
  }

  /// current PlayingTurn can be known from the initialPosition parameter, but an optional PlayingTurn can be provided using playAs paremeter
  ChessController({
    PlayingTurn? playAs,
    required this.onVictory,
    required this.onDraw,
    required this.onPieceSelected,
    required this.onPlayingTurnChanged,
    required this.onError,
    required this.onSelectPromotionType,
    required this.playSound,
    required this.updateView,
    required this.fenString,
  }) {
    if (fenString != null) {
      ChessBoardModel.clearBoard();
      List<Square> fromFen = FenParser.generateChessBoard(fenString!);
      ChessBoardModel.addAll(fromFen);
    }
    registerCallbacksListeners();
  }

  Future<void> handleSquareTapped(int index) async {
    if (sharedState.lockFurtherInteractions) {
      return;
    }

    runZonedGuarded(() async {
      /// this ensures that inMoveSelectionMode is set to true when tapping on another piece of the same type as the current playing turn
      inMoveSelectionMode = helperMethods.isInMoveSelectionMode(
          index: index,
          playingTurn: sharedState.playingTurn,
          legalMovesIndices: sharedState.legalMovesIndices);

      bool tappedOnASquareWeCanMoveTo =
          sharedState.legalMovesIndices.contains(index);

      if (inMoveSelectionMode) {
        from = index;

        sharedState.legalMovesIndices =
            await legalMovesController.getLegalMovesIndices(
          from: from!,
          ignorePlayingTurn: false,
          isKingChecked: sharedState.isKingChecked,
        );

        // for the highlight guide
        callbacks.onPieceSelected(sharedState.legalMovesIndices, index);

        // used to clear the highlighted squares when pressing an opponent piece
        inMoveSelectionMode = sharedState.legalMovesIndices.isEmpty;

        callbacks.updateView();
        return;
      }
      // checking nullability only for safely using null check operator
      else if (tappedOnASquareWeCanMoveTo && from != null) {
        if (from == null) {
          return;
        }

        // -------------------EnPassant-------------------
        bool didCaptureEnPassant = EnPassantController.handleMove(
          from: from!,
          to: index,
        );
        //--------------------Promotion-----------------------
        Pieces? pawnPromotedTo = await PromotionController.handleMove(
          from: from!,
          to: index,
        );
        //-------------------------Castling-----------------------
        CastlingController.handleMove(from: from!, to: index);
        //------------------------------------
        ChessBoardModel.move(
          from: from!,
          to: index,
          pawnPromotedTo: pawnPromotedTo,
        );
        // -------------------------------------------------
        await GameStatusController.checkStatus(index);

        sharedState.changePlayingTurn();
        //  playing the pieceMoved sound when moving to a square that is not occupied by an openent piece, otherwise playing the capture sound
        SoundType soundToPlay = (index.type() != null || didCaptureEnPassant)
            ? SoundType.capture
            : SoundType.pieceMoved;

        callbacks.playSound(soundToPlay);

        callbacks.updateView();
      }
      callbacks.onPieceSelected([], index);
      inMoveSelectionMode = true;
      sharedState.legalMovesIndices.clear();
      callbacks.updateView();
    }, (error, stack) {
      callbacks.playSound(SoundType.illegal);
      callbacks.onError(Error, stack.toString());
    });
  }
}
