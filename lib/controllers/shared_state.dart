import 'dart:async';
import 'dart:typed_data';

import 'package:chess/model/initial_model_state.dart';
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
  //----------------------------------------------------------------------------

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

  //------------------game_view-----------
  String squareName = "";
  int? selectedIndex;
  int? checkedKingIndex;
  List<int> debugHighlightIndices = [];
  //---------------home_view--------------
  String currentPlayingTurn = "White's Turn";

  Future<void> reset() async {
    stateList.clear();
    stateImages.clear();

    stateList.add(GameState(
        currentChessBoard: initialChessBoard.deepCopy(),
        legalMovesIndices: [],
        playingTurn: PlayingTurn.white,
        isKingInCheck: false,
        inMoveSelectionMode: true,
        lockFurtherInteractions: false,
        didLightKingMove: false,
        didDarkKingMove: false,
        didLightKingSideRookMove: false,
        didLightQueenSideRookMove: false,
        didDarkKingSideRookMove: false,
        didDarkQueenSideRookMove: false,
        squareName: "",
        currentPlayingTurn: "White's Turn"));

    stateIndex = 0;
    movesCount = 0;
    legalMovesIndices.clear();
    selectedPieceIndex = null;
    selectedPiece = null;
    playingTurn = PlayingTurn.white;
    isKingInCheck = false;
    enPassantCapturableLightPawnIndex = null;
    enPassantCapturableDarkPawnIndex = null;
    inMoveSelectionMode = true;
    lockFurtherInteractions = false;
    didLightKingMove = false;
    didDarkKingMove = false;
    didLightKingSideRookMove = false;
    didLightQueenSideRookMove = false;
    didDarkKingSideRookMove = false;
    didDarkQueenSideRookMove = false;
    //------------------game view--------------
    squareName = "";
    selectedIndex = null;
    checkedKingIndex = null;
    debugHighlightIndices = [];
    //------------------home_view----------------------
    currentPlayingTurn = "White's Turn";
    chessBoard.clear();
    chessBoard.addAll(initialChessBoard);
  }

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

    movesCount++;
    stateIndex++;
    stateList.add(GameState(
        currentChessBoard: chessBoard.deepCopy(),
        legalMovesIndices: legalMovesIndices.deepCopy(),
        playingTurn: playingTurn,
        isKingInCheck: isKingInCheck,
        inMoveSelectionMode: inMoveSelectionMode,
        lockFurtherInteractions: lockFurtherInteractions,
        didLightKingMove: didLightKingMove,
        didDarkKingMove: didDarkKingMove,
        didLightKingSideRookMove: didLightKingSideRookMove,
        didLightQueenSideRookMove: didLightQueenSideRookMove,
        didDarkKingSideRookMove: didDarkKingSideRookMove,
        didDarkQueenSideRookMove: didDarkQueenSideRookMove,
        squareName: squareName,
        currentPlayingTurn: currentPlayingTurn));
    ColoredPrinter.printColored(
        "Storing current state, stored states: ${stateList.length}");

    return completer.future;
  }

  void replay(ReplayType replayType) {
    late GameState state;
    if (stateList.isEmpty) {
      ColoredPrinter.printColored("no state exists");
      return;
    } else if (stateList.isNotEmpty) {
      if (replayType == ReplayType.next && stateIndex != stateList.length - 1) {
        stateIndex++;
        state = stateList[stateIndex];
        ColoredPrinter.printColored("replaying next state");
      } else if (replayType == ReplayType.previous && movesCount != 0) {
        stateIndex--;
        state = stateList[stateIndex];
        ColoredPrinter.printColored("replaying previous state");
      } else {
        ColoredPrinter.printColored("can't replay state $stateIndex");
        return;
      }
    }
    legalMovesIndices.clear();
    legalMovesIndices.addAll(state.legalMovesIndices);
    //---------------------------
    selectedPieceIndex = state.selectedPieceIndex;
    selectedPiece = state.selectedPiece;
    playingTurn = state.playingTurn;
    isKingInCheck = state.isKingInCheck;
    enPassantCapturableLightPawnIndex = state.enPassantCapturableLightPawnIndex;
    enPassantCapturableDarkPawnIndex = state.enPassantCapturableDarkPawnIndex;
    inMoveSelectionMode = state.inMoveSelectionMode;
    lockFurtherInteractions = state.lockFurtherInteractions;
    didLightKingMove = state.didLightKingMove;
    didDarkKingMove = state.didDarkKingMove;
    didLightKingSideRookMove = state.didDarkKingSideRookMove;
    didLightQueenSideRookMove = state.didLightQueenSideRookMove;
    didDarkKingSideRookMove = state.didDarkKingSideRookMove;
    didDarkQueenSideRookMove = state.didDarkQueenSideRookMove;
    //------------------game_view-----------------------------
    squareName = state.squareName;
    selectedIndex = state.selectedIndex;
    checkedKingIndex = state.checkedKingIndex;
    //------------------home_view--------
    currentPlayingTurn = state.currentPlayingTurn;
    chessBoard.clear();
    chessBoard.addAll(state.currentChessBoard);
  }
}

List<GameState> stateList = [];
List<Uint8List> stateImages = [];

enum ReplayType {
  previous,
  next,
}

int stateIndex = 0;
int movesCount = 0;

class GameState {
  List<Square> currentChessBoard;
  List<int> legalMovesIndices;
  int? selectedPieceIndex;
  Square? selectedPiece;
  PlayingTurn playingTurn;
  bool isKingInCheck;
  int? enPassantCapturableLightPawnIndex;
  int? enPassantCapturableDarkPawnIndex;
  bool inMoveSelectionMode;
  bool lockFurtherInteractions;
  bool didLightKingMove;
  bool didDarkKingMove;
  bool didLightKingSideRookMove;
  bool didLightQueenSideRookMove;
  bool didDarkKingSideRookMove;
  bool didDarkQueenSideRookMove;
  String squareName;
  int? selectedIndex;
  int? checkedKingIndex;
  String currentPlayingTurn;

  GameState(
      {required this.currentChessBoard,
      required this.legalMovesIndices,
      this.selectedPieceIndex,
      this.selectedPiece,
      required this.playingTurn,
      required this.isKingInCheck,
      this.enPassantCapturableLightPawnIndex,
      this.enPassantCapturableDarkPawnIndex,
      required this.inMoveSelectionMode,
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
