import 'dart:async';
import 'dart:typed_data';

import 'package:chess/model/chess_board_model.dart';
import 'package:chess/model/square.dart';
import 'package:chess/utils/capture_widget.dart';
import 'package:chess/utils/colored_printer.dart';
import 'package:chess/utils/extensions.dart';
import 'package:chess/utils/global_keys.dart';
import 'package:flutter/material.dart';

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
    if (activeColor == 'b') {
      fullMoveNumber++;
    }

    activeColor = activeColor == 'w' ? 'b' : 'w';

    fen = ChessBoardModel.toFen(
        activeColor: playingTurn.activeColor(),
        enPassantTargetSquare: enPassantTargetSquare,
        castlingRights: castlingRights,
        halfMoveClock: halfMoveClock,
        fullMoveNumber: fullMoveNumber);

    ColoredPrinter.printColored(fen);
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

  Future<void> storeState() async {
    // using a complete to only resolve the future once a  PostFrameCallback is received.
    Completer<void> completer = Completer<void>();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Uint8List? stateImage = await capture(GlobalKeys.captureKey);
      if (stateImage != null) {
        stateImages.add(stateImage);
        completer.complete();
      }
    });
    
    return completer.future;
  }

  void replay(ReplayType replayType) async {}
}

enum ReplayType {
  previous,
  next,
}

class GameState {
  List<Square> currentChessBoard;

  int? selectedPieceIndex;
  Square? selectedPiece;
  PlayingTurn playingTurn;

  bool lockFurtherInteractions;
  //-----------Castling----------------
  bool didLightKingMove;
  bool didDarkKingMove;
  bool didLightKingSideRookMove;
  bool didLightQueenSideRookMove;
  bool didDarkKingSideRookMove;
  bool didDarkQueenSideRookMove;
  //-------------------
  String squareName;
  int? selectedIndex;
  int? checkedKingIndex;
  String currentPlayingTurn;

  GameState(
      {required this.currentChessBoard,
      this.selectedPieceIndex,
      this.selectedPiece,
      required this.playingTurn,
      required this.lockFurtherInteractions,
      required this.didLightKingMove,
      required this.didDarkKingMove,
      required this.didLightKingSideRookMove,
      required this.didLightQueenSideRookMove,
      required this.didDarkKingSideRookMove,
      required this.didDarkQueenSideRookMove,
      required this.squareName,
      this.selectedIndex,
      this.checkedKingIndex,
      required this.currentPlayingTurn});
}
