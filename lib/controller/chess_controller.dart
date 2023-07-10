import 'dart:async';

import 'package:chess/controller/castling_controller.dart';
import 'package:chess/controller/en_passant_controller.dart';
import 'package:chess/model/square.dart';
import 'package:chess/utils/enums.dart';
import 'package:chess/controller/game_status_controller.dart';
import 'package:chess/controller/illegal_moves_controller.dart';
import 'package:chess/controller/legal_moves_controller.dart';
import 'package:chess/utils/typedefs.dart';
import 'package:chess/model/model.dart';

class ChessController {
  // -------------- callbacks------------------
  final OnDraw onDraw;
  final OnCheck onCheck;
  final OnVictory onVictory;
  final OnPlayingTurnChanged onPlayingTurnChanged;
  final OnPieceSelected onPieceSelected;
  final OnPieceMoved onPieceMoved;
  final OnError onError;
  final OnPawnPromoted onPawnPromoted;
  final OnSelectPromotionType onSelectPromotionType;
  final OnEnPassant onEnPassant;
  final PlaySound playSound;
  final UpdateView updateView;
  // ----------------------------------
  final bool playRemotely;
  bool _inMoveSelectionMode = true;
  // prevents doing anything if the game ended
  static bool lockFurtherInteractions = false;
  // ------------------------------------

  /// current PlayingTurn can be known from the initialPosition parameter, but an optional PlayingTurn can be provided using playAs paremeter
  ChessController.fromPosition({
    this.playRemotely = false,
    required this.onCheck,
    required String initialPosition,
    PlayingTurn? playAs,
    required this.onVictory,
    required this.onDraw,
    required this.onPieceSelected,
    required this.onPlayingTurnChanged,
    required this.onPieceMoved,
    required this.onError,
    required this.onPawnPromoted,
    required this.onSelectPromotionType,
    required this.onEnPassant,
    required this.playSound,
    required this.updateView,
  }) : assert(_isValidFen(fenString: initialPosition),
            'initialPosition must be a valid FEN String');


  start() {}
  pause() {}
  resume() {}
  offerDraw() {}
  resign() {}
  toggleLegalMovesHighlight() {}
  highlightLegalMovesForAllPieces() {}
  exportGame() {}
  saveGame() {}
  loadGame() {}
  requestTimerPause() {}
  getCurrentPlayingTurn() {}
  offerUndoMove() {}

  LegalMoves legalMoves = LegalMoves();
  IllegalMoves illegalMoves = IllegalMoves();
  EnPassant enPassant = EnPassant();
  CastlingController castlingController =CastlingController();
  GameStatus gameStatus =GameStatus();

  List<int> _legalMovesIndices = [];
  static int? selectedPieceIndex;
  Square? selectedPiece;
  // initial playingTurn is set to white, (todo: change this if [fromPosition] constructor was called)
  PlayingTurn _playingTurn = PlayingTurn.white;
  static bool isKingInCheck = false;

  handleSquareTapped({required int tappedSquareIndex}) async {
    lockFurtherInteractions
        ? null
        : runZonedGuarded(() async {
            Files tappedSquareFile =
                _getFileNameFromIndex(index: tappedSquareIndex);
            int tappedSquareRank =
                _getRankNameFromIndex(index: tappedSquareIndex);

            /// this ensures that inMoveSelectionMode is set to true when tapping on another piece of the same type as the current playing turn
            _inMoveSelectionMode = _isInMoveSelectionMode(
                playingTurn: _playingTurn,
                tappedSquareIndex: tappedSquareIndex,
                legalMovesIndices: _legalMovesIndices);

            if (_inMoveSelectionMode) {
              selectedPieceIndex = tappedSquareIndex;
              selectedPiece = chessBoard[tappedSquareIndex];
              _legalMovesIndices = legalMoves.getLegalMovesIndices(
                tappedSquareFile: tappedSquareFile,
                tappedSquareRank: tappedSquareRank,
                isKingChecked: isKingInCheck,
                fromHandleSquareTapped: true,
              );

              //-----------------

              // preventing player who's turn is not his to play by emptying the legalMovesIndices list
              shouldClearLegalMovesIndices(
                      playingTurn: _playingTurn,
                      selectedPieceType: selectedPiece?.pieceType)
                  ? _legalMovesIndices.clear()
                  : null;

              onPieceSelected(_legalMovesIndices, tappedSquareIndex);

              _inMoveSelectionMode = _legalMovesIndices.isEmpty;

              updateView();
              return;
            }
            // checking nullability only for safely using null check operator
            else if (_legalMovesIndices.contains(tappedSquareIndex) &&
                selectedPiece != null &&
                selectedPieceIndex != null) {
              late SoundType soundToPlay;
              // pawn will be promoted to queen by default
              Pieces promotedPawn = Pieces.queen;
              Files selectedPieceFile =
                  _getFileNameFromIndex(index: selectedPieceIndex!);
              int selectedPieceRank =
                  _getRankNameFromIndex(index: selectedPieceIndex!);

              _playingTurn = _playingTurn == PlayingTurn.white
                  ? PlayingTurn.black
                  : PlayingTurn.white;
              onPlayingTurnChanged(_playingTurn);

              bool didCaptureEnPassant = enPassant.didCaptureEnPassant(
                movedPieceType: selectedPiece?.pieceType,
                didMovePawn: selectedPiece!.piece == Pieces.pawn,
                didMoveToEmptySquareOnDifferentFile:
                    selectedPieceFile != tappedSquareFile &&
                        chessBoard[tappedSquareIndex].piece == null,
              );

              soundToPlay = (chessBoard[tappedSquareIndex].piece != null ||
                      didCaptureEnPassant)
                  ? SoundType.capture
                  : SoundType.pieceMoved;
              // moving the rook in case a king castled
              moveRookOnCastle(tappedSquareIndex: tappedSquareIndex);

              onPieceMoved(selectedPieceIndex!, tappedSquareIndex);

              enPassant.addPawnToEnPassantCapturablePawns(
                  fromRank: selectedPieceRank,
                  toRank: tappedSquareRank,
                  piece: selectedPiece!.piece,
                  movedToIndex: tappedSquareIndex,
                  pawnType:selectedPiece!.pieceType);

              bool shouldPromotePawn = shouldPawnBePromoted(
                  selectedPiecePiece: selectedPiece?.piece,
                  tappedSquareRank: tappedSquareRank);

              shouldPromotePawn
                  ? await onSelectPromotionType(
                          _playingTurn == PlayingTurn.white
                              ? PlayingTurn.black
                              : PlayingTurn.white)
                      .then((selectedPromotionType) {
                      promotedPawn = selectedPromotionType;
                      onPawnPromoted(tappedSquareIndex, selectedPromotionType);
                    })
                  : null;

              // empty square that will replace the square on which the piece that we will move is at
              Square emptySquareAtSelectedPieceIndex = Square(
                  file: selectedPieceFile,
                  rank: selectedPieceRank,
                  piece: null,
                  pieceType: null);
              Square newSquareAtTappedIndex = Square(
                file: tappedSquareFile,
                rank: tappedSquareRank,
                piece: shouldPromotePawn ? promotedPawn : selectedPiece?.piece,
                pieceType: selectedPiece?.pieceType,
              );
              Square emptyEnPassantCapturedPawnSquare = Square(
                  file: tappedSquareFile,
                  rank: selectedPieceRank,
                  piece: null,
                  pieceType: null);

              if (didCaptureEnPassant) {
                enPassant.updateBoardAfterEnPassant(tappedSquareFile,
                    selectedPieceFile, emptyEnPassantCapturedPawnSquare);
                onEnPassant(selectedPieceIndex! +
                    (tappedSquareFile.index > selectedPieceFile.index ? 1 : -1));
              }
              castlingController.changeCastlingAvailability(
                  movedPiece: selectedPiece!.piece!,
                  movedPieceType: selectedPiece!.pieceType!,
                  indexPieceMovedFrom: selectedPieceIndex!);

              chessBoard[tappedSquareIndex] = newSquareAtTappedIndex;
              chessBoard[selectedPieceIndex!] =
                  emptySquareAtSelectedPieceIndex;
              isKingInCheck =
                  isKingSquareAttacked(playingTurn: _playingTurn);
              if (isKingInCheck) {
                onCheck(chessBoard.indexWhere((piece) =>
                    piece.pieceType != selectedPiece?.pieceType &&
                    piece.piece == Pieces.king));
                if (gameStatus.isCheckmate(attackedPlayer: _playingTurn)) {
                  preventFurtherInteractions(true);
                  onVictory(VictoryType.checkmate);
                  playSound(SoundType.victory);
                }
              }

              if (gameStatus.checkForStaleMate(
                  opponentKingType: selectedPiece?.pieceType == PieceType.light
                      ? PieceType.dark
                      : PieceType.light)) {
                 onDraw(DrawType.stalemate);
                soundToPlay = SoundType.draw;
              }

              playSound(soundToPlay);

              updateView();
            }
            onPieceSelected([], tappedSquareIndex);
            _inMoveSelectionMode = true;
            _legalMovesIndices.clear();
          }, (error, stack) {
            onError(Error, stack.toString());
          });
  }

  bool _isInMoveSelectionMode(
      {required int tappedSquareIndex,
        required PlayingTurn playingTurn,
        required List<int> legalMovesIndices}) {
    bool inMoveSelectionMode =
    // pressing on an empty square or on a square occupied by an enemy piece that is not in the legal moves should not change the value to false
    ((chessBoard[tappedSquareIndex].pieceType == null ||
        (chessBoard[tappedSquareIndex].pieceType ==
            PieceType.light &&
            _playingTurn != PlayingTurn.white) ||
        (chessBoard[tappedSquareIndex].pieceType ==
            PieceType.dark &&
            _playingTurn != PlayingTurn.black)) &&
        !legalMovesIndices.contains(tappedSquareIndex)) ||
        (chessBoard[tappedSquareIndex].pieceType == PieceType.light &&
            _playingTurn == PlayingTurn.white) ||
        (chessBoard[tappedSquareIndex].pieceType == PieceType.dark &&
            _playingTurn == PlayingTurn.black);
    return inMoveSelectionMode;
  }
  bool shouldClearLegalMovesIndices(
      {required PieceType? selectedPieceType,
        required PlayingTurn playingTurn}) {
    bool shouldClearLegalMovesIndices =
    ((selectedPiece?.pieceType == PieceType.light &&
        _playingTurn != PlayingTurn.white) ||
        (selectedPiece?.pieceType == PieceType.dark &&
            _playingTurn != PlayingTurn.black));
    return shouldClearLegalMovesIndices;
  }
  static preventFurtherInteractions(bool status) {
    lockFurtherInteractions = status;
  }
  //--------------------------------
  Files _getFileNameFromIndex({required int index}) {
    List<Files> files = [
      Files.a,
      Files.b,
      Files.c,
      Files.d,
      Files.e,
      Files.f,
      Files.g,
      Files.h
    ];
    index++;
    int rank = (index / 8).ceil();
    Files file = files[index - 8 * (rank - 1) - 1];
    return file;
  }
  int _getRankNameFromIndex({required int index}) {
    index++;
    int rank = (index / 8).ceil();
    return rank;
  }
  // ---------------------
  bool shouldPawnBePromoted(
      {required Pieces? selectedPiecePiece, required tappedSquareRank}) {
    return selectedPiecePiece == Pieces.pawn &&
        (tappedSquareRank == 1 || tappedSquareRank == 8);
  }
  void moveRookOnCastle({required int tappedSquareIndex}) {
    if (selectedPiece?.piece == Pieces.king) {
      if (selectedPiece?.pieceType == PieceType.dark &&
          selectedPieceIndex! == 60 &&
          (tappedSquareIndex == 62 || tappedSquareIndex == 58)) {
        // moving the rook and updating the board
        if (tappedSquareIndex == 62) {
          onPieceMoved(63, 61);
          chessBoard[63].piece = null;
          chessBoard[63].pieceType = null;
          chessBoard[61].piece = Pieces.rook;
          chessBoard[61].pieceType = PieceType.dark;
        } else {
          onPieceMoved(56, 59);
          chessBoard[56].piece = null;
          chessBoard[56].pieceType = null;
          chessBoard[59].piece = Pieces.rook;
          chessBoard[59].pieceType = PieceType.dark;
        }
      } else if (selectedPiece?.pieceType == PieceType.light &&
          selectedPieceIndex! == 4 &&
          (tappedSquareIndex == 2 || tappedSquareIndex == 6)) {
        if (tappedSquareIndex == 6) {
          onPieceMoved(7, 5);
          chessBoard[7].piece = null;
          chessBoard[7].pieceType = null;
          chessBoard[5].piece = Pieces.rook;
          chessBoard[5].pieceType = PieceType.light;
        } else {
          onPieceMoved(0, 3);
          chessBoard[0].piece = null;
          chessBoard[0].pieceType = null;
          chessBoard[3].piece = Pieces.rook;
          chessBoard[3].pieceType = PieceType.light;
        }
      }
    }
  }
}


bool _isValidFen({required fenString}) {
  return true;
}
