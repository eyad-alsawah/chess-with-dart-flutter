import 'dart:async';
import 'package:chess/controllers/enums.dart';
import 'package:chess/controllers/typedefs.dart';
import 'package:chess/model/global_state.dart';
import 'package:chess/model/model.dart';
import 'package:chess/model/square.dart';

//--------------Main Game Controller-------------------
class ChessController {
  final OnVictory onVictory;
  final OnPlayingTurnChanged onPlayingTurnChanged;
  final OnPieceSelected onPieceSelected;
  final OnPieceMoved onPieceMoved;
  final OnError onError;
  final OnSelectPromotionType onSelectPromotionType;
  final PlaySound playSound;
  final UpdateView updateView;
//-------------------------------------------

  //----------------------------------------------------------------------------
  void registerCallbacksListeners() {
    callbacks.onVictory = onVictory;
    callbacks.onPlayingTurnChanged = onPlayingTurnChanged;
    callbacks.onPieceSelected = onPieceSelected;
    callbacks.onPieceMoved = onPieceMoved;
    callbacks.onError = onError;
    callbacks.onSelectPromotionType = onSelectPromotionType;
    callbacks.playSound = playSound;
    callbacks.updateView = updateView;
  }

  /// current PlayingTurn can be known from the initialPosition parameter, but an optional PlayingTurn can be provided using playAs paremeter
  ChessController({
    PlayingTurn? playAs,
    required this.onVictory,
    required this.onPieceSelected,
    required this.onPlayingTurnChanged,
    required this.onPieceMoved,
    required this.onError,
    required this.onSelectPromotionType,
    required this.playSound,
    required this.updateView,
  }) {
    registerCallbacksListeners();
  }

  handleSquareTapped({required int tappedSquareIndex}) async {
    sharedState.lockFurtherInteractions
        ? null
        : runZonedGuarded(() async {
            Files tappedSquareFile =
                helperMethods.getFileNameFromIndex(index: tappedSquareIndex);
            int tappedSquareRank =
                helperMethods.getRankNameFromIndex(index: tappedSquareIndex);

            /// this ensures that inMoveSelectionMode is set to true when tapping on another piece of the same type as the current playing turn
            sharedState.inMoveSelectionMode =
                helperMethods.isInMoveSelectionMode(
                    playingTurn: sharedState.playingTurn,
                    tappedSquareIndex: tappedSquareIndex,
                    legalMovesIndices: sharedState.legalMovesIndices);

            if (sharedState.inMoveSelectionMode) {
              sharedState.selectedPieceIndex = tappedSquareIndex;
              sharedState.selectedPiece = chessBoard[tappedSquareIndex];
              sharedState.legalMovesIndices =
                  legalMovesController.getLegalMovesIndices(
                tappedSquareFile: tappedSquareFile,
                tappedSquareRank: tappedSquareRank,
                isKingChecked: sharedState.isKingInCheck,
                fromHandleSquareTapped: true,
              );

              //-----------------

              // preventing player who's turn is not his to play by emptying the legalMovesIndices list
              helperMethods.shouldClearLegalMovesIndices(
                      playingTurn: sharedState.playingTurn,
                      selectedPieceType: sharedState.selectedPiece?.pieceType)
                  ? sharedState.legalMovesIndices.clear()
                  : null;

              callbacks.onPieceSelected(
                  sharedState.legalMovesIndices, tappedSquareIndex);

              sharedState.inMoveSelectionMode =
                  sharedState.legalMovesIndices.isEmpty;

              callbacks.updateView();
              return;
            }
            // checking nullability only for safely using null check operator
            else if (sharedState.legalMovesIndices
                    .contains(tappedSquareIndex) &&
                sharedState.selectedPiece != null &&
                sharedState.selectedPieceIndex != null) {
              late SoundType soundToPlay;
              // pawn will be promoted to queen by default
              Pieces promotedPawn = Pieces.queen;
              Files selectedPieceFile = helperMethods.getFileNameFromIndex(
                  index: sharedState.selectedPieceIndex!);
              int selectedPieceRank = helperMethods.getRankNameFromIndex(
                  index: sharedState.selectedPieceIndex!);

              sharedState.playingTurn =
                  sharedState.playingTurn == PlayingTurn.white
                      ? PlayingTurn.black
                      : PlayingTurn.white;
              callbacks.onPlayingTurnChanged(sharedState.playingTurn);

              bool didCaptureEnPassant =
                  enPassantController.didCaptureEnPassant(
                movedPieceType: sharedState.selectedPiece?.pieceType,
                didMovePawn: sharedState.selectedPiece!.piece == Pieces.pawn,
                didMoveToEmptySquareOnDifferentFile:
                    selectedPieceFile != tappedSquareFile &&
                        chessBoard[tappedSquareIndex].piece == null,
              );

              soundToPlay = (chessBoard[tappedSquareIndex].piece != null ||
                      didCaptureEnPassant)
                  ? SoundType.capture
                  : SoundType.pieceMoved;
              // moving the rook in case a king castled
              castlingController.moveRookOnCastle(
                  tappedSquareIndex: tappedSquareIndex);

              callbacks.onPieceMoved(
                  sharedState.selectedPieceIndex!, tappedSquareIndex);

              enPassantController.addPawnToEnPassantCapturablePawns(
                  fromRank: selectedPieceRank,
                  toRank: tappedSquareRank,
                  piece: sharedState.selectedPiece!.piece,
                  movedToIndex: tappedSquareIndex,
                  pawnType: sharedState.selectedPiece!.pieceType);

              bool shouldPromotePawn = promotionController.shouldPawnBePromoted(
                  selectedPiecePiece: sharedState.selectedPiece?.piece,
                  tappedSquareRank: tappedSquareRank);

              shouldPromotePawn
                  ? await callbacks
                      .onSelectPromotionType(
                          sharedState.playingTurn == PlayingTurn.white
                              ? PlayingTurn.black
                              : PlayingTurn.white)
                      .then((selectedPromotionType) {
                      promotedPawn = selectedPromotionType;
                      chessBoard[tappedSquareIndex].piece =
                          selectedPromotionType;
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
                piece: shouldPromotePawn
                    ? promotedPawn
                    : sharedState.selectedPiece?.piece,
                pieceType: sharedState.selectedPiece?.pieceType,
              );
              Square emptyEnPassantCapturedPawnSquare = Square(
                  file: tappedSquareFile,
                  rank: selectedPieceRank,
                  piece: null,
                  pieceType: null);

              if (didCaptureEnPassant) {
                enPassantController.updateBoardAfterEnPassant(tappedSquareFile,
                    selectedPieceFile, emptyEnPassantCapturedPawnSquare);
              }
              castlingController.changeCastlingAvailability(
                  movedPiece: sharedState.selectedPiece!.piece!,
                  movedPieceType: sharedState.selectedPiece!.pieceType!,
                  indexPieceMovedFrom: sharedState.selectedPieceIndex!);

              chessBoard[tappedSquareIndex] = newSquareAtTappedIndex;
              chessBoard[sharedState.selectedPieceIndex!] =
                  emptySquareAtSelectedPieceIndex;
              sharedState.isKingInCheck = gameStatusController
                  .isKingSquareAttacked(playingTurn: sharedState.playingTurn);
              if (sharedState.isKingInCheck) {
                sharedState.checkedKingIndex = chessBoard.indexWhere((piece) =>
                    piece.pieceType != sharedState.selectedPiece?.pieceType &&
                    piece.piece == Pieces.king);
                if (gameStatusController.isCheckmate(
                    attackedPlayer: sharedState.playingTurn)) {
                  helperMethods.preventFurtherInteractions(true);
                  callbacks.onVictory(VictoryType.checkmate);
                  callbacks.playSound(SoundType.victory);
                }
              }

              if (gameStatusController.checkForStaleMate(
                  opponentKingType:
                      sharedState.selectedPiece?.pieceType == PieceType.light
                          ? PieceType.dark
                          : PieceType.light)) {
                soundToPlay = SoundType.draw;
              }

              callbacks.playSound(soundToPlay);

              callbacks.updateView();
            }
            callbacks.onPieceSelected([], tappedSquareIndex);
            sharedState.inMoveSelectionMode = true;
            sharedState.legalMovesIndices.clear();
          }, (error, stack) {
            callbacks.onError(Error, stack.toString());
          });
  }
}
