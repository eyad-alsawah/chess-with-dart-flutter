import 'dart:async';
import 'package:chess/controllers/enums.dart';
import 'package:chess/controllers/typedefs.dart';
import 'package:chess/model/global_state.dart';
import 'package:chess/model/chess_board_model.dart';
import 'package:chess/model/square.dart';
import 'package:chess/utils/fen_parser.dart';

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
  final OnDraw onDraw;
  final String? fenString;
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
    callbacks.onDraw = onDraw;
  }

  /// current PlayingTurn can be known from the initialPosition parameter, but an optional PlayingTurn can be provided using playAs paremeter
  ChessController({
    PlayingTurn? playAs,
    required this.onVictory,
    required this.onDraw,
    required this.onPieceSelected,
    required this.onPlayingTurnChanged,
    required this.onPieceMoved,
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

  Future<void> handleSquareTapped({required int tappedSquareIndex}) async {
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
              sharedState.selectedPiece =
                  ChessBoardModel.getSquareAtIndex(tappedSquareIndex);

              sharedState.legalMovesIndices =
                  await legalMovesController.getLegalMovesIndices(
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

              // for the highlight guide
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
              Square? selectedPiece = sharedState.selectedPiece?.copy();
              Files selectedPieceFile = selectedPiece!.file;
              int selectedPieceRank = selectedPiece.rank;
              //------------------------------
              late SoundType soundToPlay;
              // pawn will be promoted to queen by default
              Pieces promotedPawn = Pieces.queen;

              // changing the playing turn
              sharedState.playingTurn =
                  sharedState.playingTurn == PlayingTurn.white
                      ? PlayingTurn.black
                      : PlayingTurn.white;
              callbacks.onPlayingTurnChanged(sharedState.playingTurn);

              bool didCaptureEnPassant =
                  enPassantController.didCaptureEnPassant(
                movedPieceType: selectedPiece.pieceType,
                didMovePawn: selectedPiece.piece == Pieces.pawn,
                didMoveToEmptySquareOnDifferentFile:
                    selectedPieceFile != tappedSquareFile &&
                        (ChessBoardModel.getSquareAtIndex(tappedSquareIndex))
                                .piece ==
                            null,
              );
              // playing the pieceMoved sound when moving to a square that is not occupied by an openent piece, otherwise playing the capture sound
              soundToPlay =
                  ((ChessBoardModel.getSquareAtIndex(tappedSquareIndex))
                                  .piece !=
                              null ||
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
                  piece: selectedPiece.piece,
                  movedToIndex: tappedSquareIndex,
                  pawnType: selectedPiece.pieceType);

              bool shouldPromotePawn = promotionController.shouldPawnBePromoted(
                  selectedPiecePiece: selectedPiece.piece,
                  tappedSquareRank: tappedSquareRank);

              shouldPromotePawn
                  ? await callbacks
                      .onSelectPromotionType(
                          sharedState.playingTurn == PlayingTurn.white
                              ? PlayingTurn.black
                              : PlayingTurn.white)
                      .then((selectedPromotionType) {
                      promotedPawn = selectedPromotionType;
                      ChessBoardModel.updateSquareAtIndex(
                        tappedSquareIndex,
                        selectedPromotionType,
                        sharedState.playingTurn == PlayingTurn.white
                            ? PieceType.light
                            : PieceType.dark,
                      );
                    })
                  : null;

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
              //------------------------------------
              ChessBoardModel.updateSquareAtIndex(
                  tappedSquareIndex,
                  shouldPromotePawn ? promotedPawn : selectedPiece.piece,
                  selectedPiece.pieceType);
              ChessBoardModel.emptySquareAtIndex(
                  sharedState.selectedPieceIndex!);
              sharedState.isKingInCheck = await gameStatusController
                  .isKingSquareAttacked(playingTurn: sharedState.playingTurn);
              //--------------------------------------------------
              if (sharedState.isKingInCheck) {
                sharedState.checkedKingIndex =
                    ChessBoardModel.getIndexWherePieceAndPieceTypeMatch(
                        Pieces.king, selectedPiece.pieceType,
                        matchPiece: true, matchType: false);

                if (await gameStatusController.isCheckmate(
                    attackedPlayer: sharedState.playingTurn)) {
                  helperMethods.preventFurtherInteractions(true);
                  callbacks.onVictory(VictoryType.checkmate);
                  callbacks.playSound(SoundType.victory);
                }
              }

              if (await gameStatusController.checkForStaleMate(
                  opponentKingType: selectedPiece.pieceType == PieceType.light
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
            callbacks.playSound(SoundType.illegal);
            callbacks.onError(Error, stack.toString());
          });
  }
}
