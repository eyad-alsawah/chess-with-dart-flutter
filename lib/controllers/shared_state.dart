import 'dart:async';
import 'dart:typed_data';

import 'package:chess/controllers/game_status_controller.dart';
import 'package:chess/controllers/uci_controller.dart';
import 'package:chess/model/chess_board_model.dart';
import 'package:chess/model/global_state.dart';
import 'package:chess/utils/capture_widget.dart';
import 'package:chess/utils/colored_printer.dart';
import 'package:chess/utils/global_keys.dart';
import 'package:flutter/material.dart';

import '../utils/extensions.dart';
import 'enums.dart';

class SharedState {
  // Private constructor
  SharedState._private();

  // Private static instance
  static final SharedState _instance = SharedState._private();

  // Public static method to access the instance
  static SharedState get instance => _instance;
  // ---------------------------------------
  int? selectedPieceIndex;
  // todo: remove this from the codebase and use the active color instead
  PlayingTurn get playingTurn =>
      activeColor == 'w' ? PlayingTurn.light : PlayingTurn.dark;
  bool lockFurtherInteractions = false;
  //------------------game_view-----------
  String squareName = "";
  int? selectedIndex;
//------------------------------------
  List<int> debugHighlightIndices = [];
  List<int> legalMovesIndices = [];
  //---------------------------------
  int? checkedKingIndex;
  bool isKingChecked = false;
  //-----------------------------------------------General-----------------------------------------------------
  void handleMove(int from, int to, Pieces? pawnPromotionType) {
    updateHalfMoveClock(from, to);
    updateUciString(from, to, pawnPromotionType);
    if (SharedState.instance.activeColor == 'b') {
      SharedState.instance.fullMoveNumber++;
    }
    SharedState.instance.changeActiveColor();
    UciController.getBestMove(SharedState.instance.uciString);
  }

  //----------------------------------------Universal Chess Interface (UCI)------------------------------------
  String uciString =
      'position fen rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 0 moves';
  int? bestMoveStartPos;
  int? bestMoveEndPos;

  void updateUciString(int from, int to, Pieces? pawnPromotionType) {
    String promotionType = '';
    switch (pawnPromotionType) {
      case Pieces.rook:
        promotionType = 'r';
        break;
      case Pieces.queen:
        promotionType = 'q';
        break;
      case Pieces.knight:
        promotionType = 'n';
        break;
      case Pieces.bishop:
        promotionType = 'b';
        break;
      default:
    }

    uciString +=
        ' ${ChessSquare.values[from].name}${ChessSquare.values[to].name}$promotionType';
  }

  String removeLastMove(String uciPosition) {
    // Split the UCI string into parts: "position", "fen", and the rest
    List<String> parts = uciPosition.split(' moves ');

    // If there are no moves, return the original position string
    if (parts.length < 2) {
      return uciPosition;
    }

    // Get the moves part and split it into individual moves
    String moves = parts[1];
    List<String> moveList = moves.split(' ');

    // Remove the last move
    if (moveList.isNotEmpty) {
      moveList.removeLast();
    }

    // Reconstruct the UCI string without the last move
    String newMoves = moveList.join(' ');
    return parts[0] + (newMoves.isNotEmpty ? ' moves $newMoves' : '');
  }

  //----------------------------------------Forsyth-Edwards Notation (FEN)-------------------------------------
  String fen = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 0';
  String activeColor = 'w';
  String enPassantTargetSquare = '-';
  String castlingRights = 'KQkq';
  // Represents how many moves both players have made since the last pawn advance or piece capture
  int halfMoveClock = 0;
  // This number is incremented by one every time Black moves.
  int fullMoveNumber = 0;

  void changeActiveColor() {
    activeColor = activeColor == 'w' ? 'b' : 'w';
  }

  void updateHalfMoveClock(int from, int to) {
    // increase halfMoveClock if no pawn was moved, or no capture happened
    if (from.piece() == Pieces.pawn || to.type() != null) {
      halfMoveClock = 0;
    } else {
      halfMoveClock++;
    }
  }

  void updateCastlingRights(
      {bool lightKingSideRookMoved = false,
      bool lightQueenSideRookMoved = false,
      bool darkKingSideRookMoved = false,
      bool darkQueenSideRookMoved = false,
      bool lightKingMoved = false,
      bool darkKingMoved = false}) {
    if (lightKingSideRookMoved) {
      castlingRights = castlingRights.replaceAll('K', '');
    } else if (lightQueenSideRookMoved) {
      castlingRights = castlingRights.replaceAll('Q', '');
    } else if (darkKingSideRookMoved) {
      castlingRights = castlingRights.replaceAll('k', '');
    } else if (darkQueenSideRookMoved) {
      castlingRights = castlingRights.replaceAll('q', '');
    } else if (lightKingMoved) {
      castlingRights = castlingRights.replaceAll(RegExp('[A-Z]'), '');
    } else if (darkKingMoved) {
      castlingRights = castlingRights.replaceAll(RegExp('[a-z]'), '');
    }

    if (castlingRights.isEmpty) {
      castlingRights = '-';
    }
  }

  //------------------------------State and restoration-------------------------------------------------
  List<Uint8List> stateImages = [];
  List<String> fenStrings = [];

  int activeStateIndex = -1;

  Future<void> storeState() async {
    // using a complete to only resolve the future once a PostFrameCallback is received.
    Completer<void> completer = Completer<void>();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Uint8List? stateImage = await capture(GlobalKeys.captureKey);
      if (stateImage != null) {
        stateImages.add(stateImage);
        completer.complete();
      }
    });

    fen = ChessBoardModel.toFen(
        activeColor: activeColor,
        enPassantTargetSquare: enPassantTargetSquare,
        castlingRights: castlingRights,
        halfMoveClock: halfMoveClock,
        fullMoveNumber: fullMoveNumber);

    fenStrings.add(fen);

    activeStateIndex++;
    ColoredPrinter.printColored(fen);
    return completer.future;
  }

  void replay(ReplayType replayType, [int? index]) async {
    String stateToReplay = '';

    switch (replayType) {
      case ReplayType.previous:
        if (activeStateIndex <= 0) {
          return;
        }
        activeStateIndex--;
        stateToReplay = fenStrings[activeStateIndex];
        break;
      case ReplayType.next:
        if (activeStateIndex == fenStrings.length - 1) {
          return;
        }
        activeStateIndex++;
        stateToReplay = fenStrings[activeStateIndex];
        break;
      case ReplayType.atIndex:
        activeStateIndex = index!;
        stateToReplay = fenStrings[index];
        break;
    }
    fen = stateToReplay;
    ChessBoardModel.fromFen(stateToReplay);
    //--------------------------------------------------------
    // todo: find a cleaner way to handle the sounds, did this because of "PlayerInterruptedException" due to capture/move sounds being playing along with victory sound
    SoundType? checkOrDrawSound = await GameStatusController.checkStatus(
        activeColor == 'w' ? PieceType.light : PieceType.dark);
    if (checkOrDrawSound != null) {
      callbacks.playSound(checkOrDrawSound);
    }
  }

  void reset() {
    UciController.newGame();

    fen = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1';
    uciString = 'position fen $fen moves';
    UciController.getBestMove(uciString);
    stateImages.clear();
    fenStrings.clear();
    activeStateIndex = -1;
    ChessBoardModel.fromFen(
        'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1');
  }
}

enum ReplayType {
  previous,
  atIndex,
  next,
}
