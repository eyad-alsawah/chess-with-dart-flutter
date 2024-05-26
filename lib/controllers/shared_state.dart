import 'dart:async';
import 'dart:typed_data';

import 'package:chess/controllers/callbacks.dart';
import 'package:chess/model/chess_board_model.dart';
import 'package:chess/model/square.dart';
import 'package:chess/utils/capture_widget.dart';
import 'package:chess/utils/colored_printer.dart';
import 'package:chess/utils/fen_parser.dart';
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

  int? selectedPieceIndex;

  void changePlayingTurn() {
    playingTurn =
        playingTurn == PlayingTurn.light ? PlayingTurn.dark : PlayingTurn.light;
    Callbacks.instance.onPlayingTurnChanged(playingTurn);
  }

  bool lockFurtherInteractions = false;
  //------------------game_view-----------
  String squareName = "";
  int? selectedIndex;
//------------------------------------
  List<int> debugHighlightIndices = [];
  List<int> legalMovesIndices = [];
  //---------------------------------
  PlayingTurn playingTurn = PlayingTurn.light;
  //-------------------------------------
  bool didLightKingSideRookMove = false;
  bool didLightQueenSideRookMove = false;
  bool didDarkKingSideRookMove = false;
  bool didDarkQueenSideRookMove = false;
  bool didLightKingMove = false;
  bool didDarkKingMove = false;
//----------------------------------------------------------------------------
  int? enPassantCapturableLightPawnIndex;
  int? enPassantCapturableDarkPawnIndex;
  //--------------------------------------------
  int? checkedKingIndex;
  bool isKingChecked = false;
  //---------------home_view--------------
  String currentPlayingTurn = "White's Turn";

  Future<void> reset() async {
    stateIndex = 0;
    stateList.clear();
    stateImages.clear();

    stateList.add(GameState(
        currentChessBoard: ChessBoardModel.currentChessBoard(),
        playingTurn: PlayingTurn.light,
        lockFurtherInteractions: false,
        didLightKingMove: false,
        didDarkKingMove: false,
        didLightKingSideRookMove: false,
        didLightQueenSideRookMove: false,
        didDarkKingSideRookMove: false,
        didDarkQueenSideRookMove: false,
        squareName: "",
        currentPlayingTurn: "White's Turn"));

    movesCount = 0;

    playingTurn = PlayingTurn.light;

    lockFurtherInteractions = false;
    //------------------game view--------------
    squareName = "";

    debugHighlightIndices = [];
    //------------------home_view----------------------
    currentPlayingTurn = "White's Turn";
    await ChessBoardModel.clearBoard();

    ChessBoardModel.addAll(FenParser.generateChessBoard(
        'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1'));
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
        currentChessBoard: ChessBoardModel.currentChessBoard(),
        playingTurn: playingTurn,
        lockFurtherInteractions: lockFurtherInteractions,
        didLightKingMove: SharedState.instance.didLightKingMove,
        didDarkKingMove: SharedState.instance.didDarkKingMove,
        didLightKingSideRookMove: SharedState.instance.didLightKingSideRookMove,
        didLightQueenSideRookMove:
            SharedState.instance.didLightQueenSideRookMove,
        didDarkKingSideRookMove: SharedState.instance.didDarkKingSideRookMove,
        didDarkQueenSideRookMove: SharedState.instance.didDarkQueenSideRookMove,
        squareName: squareName,
        currentPlayingTurn: currentPlayingTurn));
    return completer.future;
  }

  void replay(ReplayType replayType) async {
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

    //---------------------------
    selectedPieceIndex = state.selectedPieceIndex;

    playingTurn = state.playingTurn;
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
    //------------------home_view--------
    currentPlayingTurn = state.currentPlayingTurn;
    await ChessBoardModel.clearBoard();
    await ChessBoardModel.addAll(state.currentChessBoard);
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

  int? selectedPieceIndex;
  Square? selectedPiece;
  PlayingTurn playingTurn;

  int? enPassantCapturableLightPawnIndex;
  int? enPassantCapturableDarkPawnIndex;

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
      this.enPassantCapturableLightPawnIndex,
      this.enPassantCapturableDarkPawnIndex,
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
