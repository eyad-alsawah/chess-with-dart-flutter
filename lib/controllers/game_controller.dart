import 'dart:async';
import 'package:chess/controllers/castling_controller.dart';
import 'package:chess/controllers/en_passent_controller.dart';
import 'package:chess/controllers/enums.dart';
import 'package:chess/controllers/game_status_controller.dart';
import 'package:chess/controllers/promotion_controller.dart';
import 'package:chess/controllers/shared_state.dart';
import 'package:chess/controllers/typedefs.dart';
import 'package:chess/model/global_state.dart';
import 'package:chess/model/chess_board_model.dart';
import 'package:chess/model/move.dart';
import 'package:chess/utils/extensions.dart';

//--------------Main Game Controller-------------------
class ChessController {
  final OnVictory onVictory;
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
    required this.onError,
    required this.onSelectPromotionType,
    required this.playSound,
    required this.updateView,
    required this.fenString,
  }) {
    if (fenString != null) {
      SharedState.instance.fen = fenString!;
      SharedState.instance.uciString = "position fen ${fenString!} moves";
      ChessBoardModel.clearBoard();
      ChessBoardModel.fromFen(fenString!);
    }

    // todo: find a better way to update the playing turn string and fen strings on the game_view without updating the view
    Future.delayed(Duration.zero).then((value) async {
      SoundType? soundToPlay = await GameStatusController.checkStatus(
          SharedState.instance.playingTurn.type());
      await SharedState.instance.storeState().then((value) {
        soundToPlay != null ? playSound(soundToPlay) : null;
        updateView();
      });
    });
    registerCallbacksListeners();
  }

  Future<void> handleSquareTapped(int index) async {
    if (SharedState.instance.lockFurtherInteractions) {
      return;
    }

    runZonedGuarded(() async {
      /// this ensures that inMoveSelectionMode is set to true when tapping on another piece of the same type as the current playing turn
      inMoveSelectionMode = helperMethods.isInMoveSelectionMode(
          index: index,
          playingTurn: SharedState.instance.playingTurn,
          legalMovesIndices: SharedState.instance.legalMovesIndices);

      bool tappedOnASquareWeCanMoveTo =
          SharedState.instance.legalMovesIndices.contains(index);

      if (inMoveSelectionMode) {
        from = index;
        SharedState.instance.legalMovesIndices =
            await legalMovesController.getLegalMovesIndices(
          from: from!,
          ignorePlayingTurn: false,
          isKingChecked: SharedState.instance.isKingChecked,
        );

        // for the highlight guide
        callbacks.onPieceSelected(
            SharedState.instance.legalMovesIndices, index);

        // used to clear the highlighted squares when pressing an opponent piece
        inMoveSelectionMode = SharedState.instance.legalMovesIndices.isEmpty;
      }
      // checking nullability only for safely using null check operator
      else if (tappedOnASquareWeCanMoveTo && from != null) {
        // this is used to determine wether to play a moving sound or a capture sound, because we can't determine the piece of the square we moved to at index after performing the move
        PieceType? toPieceType = index.type();
        // -------------------EnPassant-------------------
        bool didCaptureEnPassant = EnPassantController.handleMove(
          from: from!,
          to: index,
        );
        //--------------------Promotion-----------------------
        Pieces? pawnPromotionType = await PromotionController.handleMove(
          from: from!,
          to: index,
        );
        //-------------------------Castling-----------------------
        Move? rookCastlingMove =
            CastlingController.handleMove(from: from!, to: index);
        //-------------------------FEN/UCI-----------
        SharedState.instance.handleMove(from!, index, pawnPromotionType);
        //-------------------------------------------
        ChessBoardModel.executeMove(
            from: from!,
            to: index,
            pawnPromotionType: pawnPromotionType,
            rookCastlingMove: rookCastlingMove);
        // -------------------------------------------------
        SoundType? checkOrDrawSound = await GameStatusController.checkStatus(
            index.type()?.oppositeType());
        SharedState.instance.storeState().whenComplete(() => updateView());
        //  playing the pieceMoved sound when moving to a square that is not occupied by an openent piece, otherwise playing the capture sound
        SoundType soundToPlay = checkOrDrawSound ??
            ((toPieceType != null || didCaptureEnPassant)
                ? SoundType.capture
                : SoundType.pieceMoved);

        playSound(soundToPlay);
        // ----------------clean-up------------------------------
        callbacks.onPieceSelected([], index);
        inMoveSelectionMode = true;
        SharedState.instance.legalMovesIndices.clear();
      }
      callbacks.updateView();
    }, (error, stack) {
      callbacks.playSound(SoundType.illegal);
      callbacks.onError(Error, stack.toString());
    });
  }
}
