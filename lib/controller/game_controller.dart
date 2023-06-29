import 'dart:async';

import 'package:chess/controller/enums.dart';
import 'package:chess/controller/typedefs.dart';
import 'package:chess/model/model.dart';

//--------------Main Game Controller-------------------
class ChessController {
  final OnCheck onCheck;
  final OnVictory onVictory;
  final OnDraw onDraw;
  final OnPlayingTurnChanged onPlayingTurnChanged;
  final OnPieceSelected onPieceSelected;
  final OnCastling onCastling;
  final OnPieceMoved onPieceMoved;
  final OnError onError;
  final OnPawnPromoted onPawnPromoted;
  final OnSelectPromotionType onSelectPromotionType;
  final OnEnPassant onEnPassant;
  final PlaySound playSound;
  final UpdateView updateView;
  final OnCapture onCapture;
//-------------------------------------------

  bool _inMoveSelectionMode = true;
  // prevents doing anything if the game ended
  bool lockFurtherInteractions = false;

  /// current PlayingTurn can be known from the initialPosition parameter, but an optional PlayingTurn can be provided using playAs paremeter
  ChessController.fromPosition({
    required this.onCheck,
    required this.onCapture,
    required String initialPosition,
    PlayingTurn? playAs,
    required this.onVictory,
    required this.onDraw,
    required this.onPieceSelected,
    required this.onPlayingTurnChanged,
    required this.onPieceMoved,
    required this.onError,
    required this.onCastling,
    required this.onPawnPromoted,
    required this.onSelectPromotionType,
    required this.onEnPassant,
    required this.playSound,
    required this.updateView,
  }) : assert(_isValidFen(fenString: initialPosition),
            'initialPosition must be a valid FEN String');
  //------------------------------
  start() {}
  pause() {}
  resume() {}
  offerDraw() {}
  resign() {}
  //------------------------------
  toggleLegalMovesHighlight() {}
  highlightLegalMovesForAllPieces() {}
  //--------------------------------
  exportGame() {}
  saveGame() {}
  loadGame() {}
  //-------------------------------
  requestTimerPause() {}
  //-----------------------------------
  getCurrentPlayingTurn() {}
  offerUndoMove() {}

  //---------------------------------

  List<int> _legalMovesIndices = [];
  int? _selectedPieceIndex;
  Square? _selectedPiece;
  // initial playingTurn is set to white, (todo: change this if [fromPosition] constructor was called)
  PlayingTurn _playingTurn = PlayingTurn.white;
  bool isKingInCheck =false;
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
              _selectedPieceIndex = tappedSquareIndex;
              _selectedPiece = chessBoard[tappedSquareIndex];
              _legalMovesIndices = _getLegalMovesIndices(
                  tappedSquareFile: tappedSquareFile,
                  tappedSquareRank: tappedSquareRank,
                isKingChecked: isKingInCheck,fromHandleSquareTapped: true,
             );

              // // checking for stalemate
              // List<int> allLegalMovesIndices =[];
              // for(var square in chessBoard){
              //   if(square.pieceType ==  chessBoard[tappedSquareIndex].pieceType){
              //     allLegalMovesIndices.addAll(
              //         _getLegalMovesIndices(
              //           tappedSquareFile: square.file,
              //           tappedSquareRank: square.rank,
              //           isKingChecked: isKingInCheck,
              //             fromHandleSquareTapped: true,
              //         )
              //     );
              //   }
              // }
              // // player has no legal move and an empty square was not tapped
              // if(allLegalMovesIndices.isEmpty &&chessBoard[tappedSquareIndex].pieceType!=null ){
              //   preventFurtherInteractions(true);
              //   playSound(SoundType.draw);
              //   onDraw(DrawType.stalemate);
              // }
              //------------------------------------------

              // preventing player who's turn is not his to play by emptying the legalMovesIndices list
              shouldClearLegalMovesIndices(
                      playingTurn: _playingTurn,
                      selectedPieceType: _selectedPiece?.pieceType)
                  ? _legalMovesIndices.clear()
                  : null;

              onPieceSelected(_legalMovesIndices, tappedSquareIndex);

              _inMoveSelectionMode = _legalMovesIndices.isEmpty;

              updateView();
              return;
            }
            // checking nullability only for safely using null check operator
            else if (_legalMovesIndices.contains(tappedSquareIndex) &&
                _selectedPiece != null &&
                _selectedPieceIndex != null) {
              // pawn will be promoted to queen by default
              Pieces promotedPawn = Pieces.queen;
              Files selectedPieceFile =
                  _getFileNameFromIndex(index: _selectedPieceIndex!);
              int selectedPieceRank =
                  _getRankNameFromIndex(index: _selectedPieceIndex!);

              _playingTurn = _playingTurn == PlayingTurn.white
                  ? PlayingTurn.black
                  : PlayingTurn.white;
              onPlayingTurnChanged(_playingTurn);

              bool didCaptureEnPassant = _didCaptureEnPassant(
                movedPieceType: _selectedPiece?.pieceType,
                didMovePawn: _selectedPiece!.piece == Pieces.pawn,
                didMoveToEmptySquareOnDifferentFile:
                    selectedPieceFile != tappedSquareFile &&
                        chessBoard[tappedSquareIndex].piece == null,
              );

              // moving the rook in case a king castled
              moveRookOnCastle(tappedSquareIndex: tappedSquareIndex);

              playSound((chessBoard[tappedSquareIndex].piece != null ||
                      didCaptureEnPassant)
                  ? SoundType.capture
                  : SoundType.pieceMoved);

              onPieceMoved(_selectedPieceIndex!, tappedSquareIndex);

              _addPawnToEnPassantCapturablePawns(
                  fromRank: selectedPieceRank,
                  toRank: tappedSquareRank,
                  piece: chessBoard[_selectedPieceIndex!].piece,
                  movedToIndex: tappedSquareIndex,
                  pawnType: chessBoard[_selectedPieceIndex!].pieceType);

              bool shouldPromotePawn = shouldPawnBePromoted(
                  selectedPiecePiece: _selectedPiece?.piece,
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
                piece: shouldPromotePawn ? promotedPawn : _selectedPiece?.piece,
                pieceType: _selectedPiece?.pieceType,
              );
              Square emptyEnPassantCapturedPawnSquare = Square(
                  file: tappedSquareFile,
                  rank: selectedPieceRank,
                  piece: null,
                  pieceType: null);

              if (didCaptureEnPassant) {
                updateBoardAfterEnPassant(tappedSquareFile, selectedPieceFile, emptyEnPassantCapturedPawnSquare);
              }
              changeCastlingAvailability(
                  movedPiece: _selectedPiece!.piece!,
                  movedPieceType: _selectedPiece!.pieceType!,
                  indexPieceMovedFrom: _selectedPieceIndex!);

              chessBoard[tappedSquareIndex] = newSquareAtTappedIndex;
              chessBoard[_selectedPieceIndex!] =
                  emptySquareAtSelectedPieceIndex;
              isKingInCheck = isKingSquareAttacked(playingTurn: _playingTurn);
              if (isKingInCheck) {
                onCheck(chessBoard.indexWhere((piece) =>
                    piece.pieceType != _selectedPiece?.pieceType &&
                    piece.piece == Pieces.king));
              if(isCheckmate(attackedPlayer: _playingTurn)){
                    preventFurtherInteractions(true);
                     onVictory(VictoryType.checkmate);
                     playSound(SoundType.victory);
              }
              }
              updateView();
            }
            onPieceSelected([], tappedSquareIndex);
            _inMoveSelectionMode = true;
            _legalMovesIndices.clear();
          }, (error, stack) {
            onError(Error, stack.toString());
          });
  }

  preventFurtherInteractions(bool status){
    lockFurtherInteractions =status;
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
        ((_selectedPiece?.pieceType == PieceType.light &&
                _playingTurn != PlayingTurn.white) ||
            (_selectedPiece?.pieceType == PieceType.dark &&
                _playingTurn != PlayingTurn.black));
    return shouldClearLegalMovesIndices;
  }

  bool shouldPawnBePromoted(
      {required Pieces? selectedPiecePiece, required tappedSquareRank}) {
    return selectedPiecePiece == Pieces.pawn &&
        (tappedSquareRank == 1 || tappedSquareRank == 8);
  }

  // ---------------------------------------------------------------------------
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

  List<Square> _getIllegalAndLegalMoves(
      {required int rank, required Files file}) {
    Square tappedPiece = chessBoard
        .firstWhere((element) => element.rank == rank && element.file == file);
    List<Square> moves = [];
    switch (tappedPiece.piece) {
      case Pieces.rook:
        moves = [
          ..._getHorizontalPieces(rank: rank, file: file),
          ..._getVerticalPieces(rank: rank, file: file)
        ];
        break;
      case Pieces.knight:
        moves = _getKnightPieces(rank: rank, file: file);
        break;
      case Pieces.bishop:
        moves = _getDiagonalPieces(rank: rank, file: file);
        break;

      case Pieces.queen:
        moves = [
          ..._getHorizontalPieces(rank: rank, file: file),
          ..._getVerticalPieces(rank: rank, file: file),
          ..._getDiagonalPieces(rank: rank, file: file)
        ];
        break;
      case Pieces.king:
        moves = _getKingPieces(rank: rank, file: file);
        break;
      case Pieces.pawn:
        moves = _getPawnPieces(rank: rank, file: file);
        break;
      default:
        moves.clear();
    }
    return moves;
  }

  /// ---------------------------------En Passant---------------
  int? _enPassantCapturableLightPawnIndex;
  int? _enPassantCapturableDarkPawnIndex;

  void _addPawnToEnPassantCapturablePawns(
      {required int fromRank,
      required int toRank,
      required Pieces? piece,
      required int movedToIndex,
      required PieceType? pawnType}) {
    if (piece == Pieces.pawn &&
        ((fromRank == 2 && toRank == 4) || (fromRank == 7 && toRank == 5))) {
      if (pawnType == PieceType.light) {
        _enPassantCapturableLightPawnIndex = movedToIndex;
      } else {
        _enPassantCapturableDarkPawnIndex = movedToIndex;
      }
    }
  }

  void _removePawnFromEnPassantCapturablePawns({
    required PieceType? movedPieceType,
  }) {
    if (movedPieceType == PieceType.light) {
      _enPassantCapturableDarkPawnIndex = null;
    } else if (movedPieceType == PieceType.dark) {
      _enPassantCapturableLightPawnIndex = null;
    } else {
      print(
          "this condition will only be reached if player tapped on empty square in selection mode which shouldn't happen because in handleTap we are checking if we pressed on a highlighted index in selection mode");
    }
  }

  bool _didCaptureEnPassant({
    required bool didMovePawn,
    required bool didMoveToEmptySquareOnDifferentFile,
    required PieceType? movedPieceType,
  }) {
    bool didCaptureEnPassent =
        didMovePawn && didMoveToEmptySquareOnDifferentFile;
    _removePawnFromEnPassantCapturablePawns(movedPieceType: movedPieceType);
    return didCaptureEnPassent;
  }

  bool _canCaptureEnPassant({
    required int fromIndex,
    required int toIndex,
    required int fromRank,
    required PieceType selectedPawnType,
    required RelativeDirection relativeDirection,
  }) {
    bool canCaptureEnPassant = false;
    int? indexToCheck = selectedPawnType == PieceType.light
        ? _enPassantCapturableDarkPawnIndex
        : _enPassantCapturableLightPawnIndex;

    if ((selectedPawnType == PieceType.light && fromRank == 5) ||
        (selectedPawnType == PieceType.dark && fromRank == 4)) {
      if (relativeDirection == RelativeDirection.diagonalTopLeft ||
          relativeDirection == RelativeDirection.diagonalBottomLeft) {
        canCaptureEnPassant = indexToCheck != null &&
            fromIndex > indexToCheck &&
            chessBoard[toIndex].piece == null;
      } else {
        canCaptureEnPassant = indexToCheck != null &&
            fromIndex < indexToCheck &&
            chessBoard[toIndex].piece == null;
      }
    }

    return canCaptureEnPassant;
  }

  void updateBoardAfterEnPassant(Files tappedSquareFile, Files selectedPieceFile, Square emptyEnPassantCapturedPawnSquare) {
    chessBoard[_selectedPieceIndex! +
        (tappedSquareFile.index > selectedPieceFile.index
            ? 1
            : -1)] = emptyEnPassantCapturedPawnSquare;
    onEnPassant(_selectedPieceIndex! +
        (tappedSquareFile.index > selectedPieceFile.index
            ? 1
            : -1));
  }

  /// --------------------------------LegalMoves getters----------------------
  ///  ------------------------------------Castling-------------------------
  bool didLightKingMove = false;
  bool didDarkKingMove = false;
  bool didLightKingSideRookMove = false;
  bool didLightQueenSideRookMove = false;
  bool didDarkKingSideRookMove = false;
  bool didDarkQueenSideRookMove = false;

  List<Square> getCastlingAvailability({required PieceType pieceType}) {
    List<Square> castlingAvailability;
    if (pieceType == PieceType.light) {
      if (didLightKingMove) {
        castlingAvailability = [];
      } else if (didLightKingSideRookMove) {
        castlingAvailability = didLightQueenSideRookMove ? [] : [chessBoard[2]];
      } else {
        castlingAvailability = didLightQueenSideRookMove
            ? [chessBoard[6]]
            : [chessBoard[2], chessBoard[6]];
      }
    } else {
      if (didDarkKingMove) {
        castlingAvailability = [];
      } else if (didDarkKingSideRookMove) {
        castlingAvailability = didDarkQueenSideRookMove ? [] : [chessBoard[58]];
      } else {
        castlingAvailability = didDarkQueenSideRookMove
            ? [chessBoard[62]]
            : [chessBoard[58], chessBoard[62]];
      }
    }
    return castlingAvailability;
  }

  void changeCastlingAvailability(
      {required Pieces movedPiece,
      required PieceType movedPieceType,
      required int indexPieceMovedFrom}) {
    // checking if castling is possible in the first place before checking all the other conditions
    bool canWhiteKingCastle = !didLightKingMove &&
        (!didLightKingSideRookMove || !didLightQueenSideRookMove);
    bool canBlackKingCastle = !didDarkKingMove &&
        (!didDarkKingSideRookMove || !didDarkQueenSideRookMove);

    if (movedPieceType == PieceType.dark && !canBlackKingCastle) {
      return;
    }
    if (movedPieceType == PieceType.light && !canWhiteKingCastle) {
      return;
    }
    // todo: check castling availability on the start of the game by checking the existing pieces on the squares like the a1 and h8 for example
    if (movedPiece == Pieces.king) {
      if (movedPieceType == PieceType.light) {
        didLightKingMove = true;
      } else {
        didDarkKingMove = true;
      }
    } else if (movedPiece == Pieces.rook) {
      if (movedPieceType == PieceType.light) {
        if (indexPieceMovedFrom == 0) {
          didLightQueenSideRookMove = true;
        } else if (indexPieceMovedFrom == 7) {
          didLightKingSideRookMove = true;
        }
      } else {
        if (indexPieceMovedFrom == 56) {
          didDarkQueenSideRookMove = true;
        } else if (indexPieceMovedFrom == 63) {
          didDarkKingSideRookMove = true;
        }
      }
    }
  }

  void moveRookOnCastle({required int tappedSquareIndex}) {
    if (_selectedPiece?.piece == Pieces.king) {
      if (_selectedPiece?.pieceType == PieceType.dark &&
          _selectedPieceIndex! == 60 &&
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
      } else if (_selectedPiece?.pieceType == PieceType.light &&
          _selectedPieceIndex! == 4 &&
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
  //------------------------------------------------
  List<Square> _getPawnPieces({required int rank, required Files file}) {
    Square currentPiece = chessBoard
        .firstWhere((element) => element.rank == rank && element.file == file);
    int currentIndex = chessBoard.indexOf(currentPiece);

    List<Square> pawnPieces = [];

    if (currentPiece.pieceType == PieceType.light) {
      //top-right
      (file != Files.h &&
              rank != 8 &&
              (chessBoard[currentIndex + 9].pieceType != null ||
                  _canCaptureEnPassant(
                    fromRank: rank,
                    fromIndex: currentIndex,
                    toIndex: currentIndex + 9,
                    selectedPawnType: PieceType.light,
                    relativeDirection: RelativeDirection.diagonalTopRight,
                  )))
          ? pawnPieces.add(chessBoard[currentIndex + 9])
          : null;
      //top-left
      (file != Files.a &&
              rank != 8 &&
              (chessBoard[currentIndex + 7].pieceType != null ||
                  _canCaptureEnPassant(
                    fromRank: rank,
                    fromIndex: currentIndex,
                    toIndex: currentIndex + 7,
                    selectedPawnType: PieceType.light,
                    relativeDirection: RelativeDirection.diagonalTopLeft,
                  )))
          ? pawnPieces.add(chessBoard[currentIndex + 7])
          : null;
      //top
      (rank != 8 && chessBoard[currentIndex + 8].pieceType == null)
          ? (rank == 2 && chessBoard[currentIndex + 16].pieceType == null)
              ? pawnPieces.addAll(
                  [chessBoard[currentIndex + 8], chessBoard[currentIndex + 16]])
              : pawnPieces.add(chessBoard[currentIndex + 8])
          : null;
    } else if (currentPiece.pieceType == PieceType.dark) {
      //bottom-right
      (file != Files.h &&
              rank != 1 &&
              (chessBoard[currentIndex - 7].pieceType != null ||
                  _canCaptureEnPassant(
                    fromRank: rank,
                    fromIndex: currentIndex,
                    toIndex: currentIndex - 7,
                    selectedPawnType: PieceType.dark,
                    relativeDirection: RelativeDirection.diagonalBottomRight,
                  )))
          ? pawnPieces.add(chessBoard[currentIndex - 7])
          : null;
      //bottom-left
      (file != Files.a &&
              rank != 1 &&
              (chessBoard[currentIndex - 9].pieceType != null ||
                  _canCaptureEnPassant(
                    fromRank: rank,
                    fromIndex: currentIndex,
                    toIndex: currentIndex - 9,
                    selectedPawnType: PieceType.dark,
                    relativeDirection: RelativeDirection.diagonalBottomLeft,
                  )))
          ? pawnPieces.add(chessBoard[currentIndex - 9])
          : null;
      //bottom
      (rank != 1 && chessBoard[currentIndex - 8].pieceType == null)
          ? (rank == 7 && chessBoard[currentIndex - 16].pieceType == null)
              ? pawnPieces.addAll(
                  [chessBoard[currentIndex - 8], chessBoard[currentIndex - 16]])
              : pawnPieces.add(chessBoard[currentIndex - 8])
          : null;
    }
    return pawnPieces;
  }

  List<Square> _getKingPieces(
      {required int rank, required Files file, bool getCastlingPieces = true}) {
    Square currentPiece = chessBoard
        .firstWhere((element) => element.rank == rank && element.file == file);
    int index = chessBoard.indexOf(currentPiece);
    int currentIndex = index;

    List<Square> kingPieces = [];

    // castling:
    getCastlingPieces
        ? kingPieces
            .addAll(getCastlingAvailability(pieceType: currentPiece.pieceType!))
        : null;

    //right
    (file != Files.h) ? kingPieces.add(chessBoard[currentIndex + 1]) : null;
    //left
    (file != Files.a) ? kingPieces.add(chessBoard[currentIndex - 1]) : null;
    //top-right
    (file != Files.h && rank != 8)
        ? kingPieces.add(chessBoard[currentIndex + 9])
        : null;
    //top-left
    (file != Files.a && rank != 8)
        ? kingPieces.add(chessBoard[currentIndex + 7])
        : null;
    //top
    rank != 8 ? kingPieces.add(chessBoard[currentIndex + 8]) : null;

    //bottom-right
    (file != Files.h && rank != 1)
        ? kingPieces.add(chessBoard[currentIndex - 7])
        : null;
    //bottom-left
    (file != Files.a && rank != 1)
        ? kingPieces.add(chessBoard[currentIndex - 9])
        : null;
    //bottom
    rank != 1 ? kingPieces.add(chessBoard[currentIndex - 8]) : null;

    return kingPieces;
  }

  List<Square> _getKnightPieces({required int rank, required Files file}) {
    Square currentPiece = chessBoard
        .firstWhere((element) => element.rank == rank && element.file == file);
    int index = chessBoard.indexOf(currentPiece);
    int currentIndex = index;

    List<Square> knightPieces = [];

    //top-right
    (file != Files.h && rank <= 6)
        ? knightPieces.add(chessBoard[currentIndex + 17])
        : null;
    //top-left
    (file != Files.a && rank <= 6)
        ? knightPieces.add(chessBoard[currentIndex + 15])
        : null;
    //----------
    //bottom-right
    (file != Files.h && rank >= 3)
        ? knightPieces.add(chessBoard[currentIndex - 15])
        : null;
    //bottom-left
    (file != Files.a && rank >= 3)
        ? knightPieces.add(chessBoard[currentIndex - 17])
        : null;
    //---------
    //right-top
    (file != Files.g && file != Files.h && rank != 8)
        ? knightPieces.add(chessBoard[currentIndex + 10])
        : null;
    //right-bottom
    (file != Files.g && file != Files.h && rank != 1)
        ? knightPieces.add(chessBoard[currentIndex - 6])
        : null;
    //---------
    //left-top
    (file != Files.b && file != Files.a && rank != 8)
        ? knightPieces.add(chessBoard[currentIndex + 6])
        : null;
    //left-bottom
    (file != Files.b && file != Files.a && rank != 1)
        ? knightPieces.add(chessBoard[currentIndex - 10])
        : null;

    return knightPieces;
  }

  List<Square> _getDiagonalPieces({required int rank, required Files file}) {
    Square currentPiece = chessBoard
        .firstWhere((element) => element.rank == rank && element.file == file);
    int index = chessBoard.indexOf(currentPiece);
    int currentIndex = index;
    List<Square> diagonalPieces = [];
    //-----------------------------
    //{RelativeDirection.diagonalTopRight}
    while (currentIndex < 64 &&
        !(chessBoard[currentIndex].file == Files.a && file != Files.a)) {
      diagonalPieces.add(chessBoard[currentIndex]);
      currentIndex = currentIndex + 9;
    }
    currentIndex = index;
    //{RelativeDirection.diagonalBottomLeft}
    while (currentIndex >= 0 &&
        !(chessBoard[currentIndex].file == Files.h && file != Files.h)) {
      diagonalPieces.add(chessBoard[currentIndex]);
      currentIndex = currentIndex - 9;
    }
    currentIndex = index;
    //{RelativeDirection.diagonalTopLeft}
    while (currentIndex < 63 &&
        !(chessBoard[currentIndex].file == Files.h && file != Files.h)) {
      diagonalPieces.add(chessBoard[currentIndex]);
      currentIndex = currentIndex + 7;
    }
    currentIndex = index;
    //{RelativeDirection.diagonalBottomRight}
    while (currentIndex > 0 &&
        !(chessBoard[currentIndex].file == Files.a && file != Files.a)) {
      diagonalPieces.add(chessBoard[currentIndex]);
      currentIndex = currentIndex - 7;
    }
    // remove current piece from the list
    diagonalPieces
        .removeWhere((element) => element.rank == rank && element.file == file);
    return diagonalPieces;
  }

  List<Square> _getHorizontalPieces({required int rank, required Files file}) {
    Square currentPiece = chessBoard
        .firstWhere((element) => element.rank == rank && element.file == file);
    int index = chessBoard.indexOf(currentPiece);
    int currentIndex = index;
    List<Square> horizontalPieces = [];
    while (currentIndex < rank * 8) {
      horizontalPieces.add(chessBoard[currentIndex]);
      currentIndex++;
    }
    currentIndex = index;
    while (currentIndex >= (rank - 1) * 8) {
      horizontalPieces.add(chessBoard[currentIndex]);
      currentIndex--;
    }
    // remove current piece from the list
    horizontalPieces
        .removeWhere((element) => element.rank == rank && element.file == file);
    //--------------------------------

    return horizontalPieces;
  }

//----------------------
  List<Square> _getVerticalPieces({required int rank, required Files file}) {
    Square currentPiece = chessBoard
        .firstWhere((element) => element.rank == rank && element.file == file);
    int index = chessBoard.indexOf(currentPiece);
    int currentIndex = index;
    List<Square> verticalPieces = [];

    while (currentIndex < 64) {
      verticalPieces.add(chessBoard[currentIndex]);
      currentIndex += 8;
    }
    currentIndex = index;
    while (currentIndex >= 0) {
      verticalPieces.add(chessBoard[currentIndex]);
      currentIndex -= 8;
    }
    // remove current piece from the list
    verticalPieces
        .removeWhere((element) => element.rank == rank && element.file == file);
    return verticalPieces;
  }

  //------------------------------------------Getting Legal Moves--------------------------
  List<Square> _getLegalMovesOnly(
      {required List<Square> legalAndIllegalMoves,
      required Files file,
      required int rank,
        bool fromHandleSquareTapped =false,
      bool kingChecked = false}) {
    List<Square> legalMoves = [];
    Square tappedPiece = chessBoard
        .firstWhere((element) => element.rank == rank && element.file == file);

    bool didCaptureOnRankLeft = false;
    bool didCaptureOnRankRight = false;
    bool didCaptureOnFileTop = false;
    bool didCaptureOnFileBottom = false;
    bool didCaptureOnDiagonalTopLeft = false;
    bool didCaptureOnDiagonalTopRight = false;
    bool didCaptureOnDiagonalBottomLeft = false;
    bool didCaptureOnDiagonalBottomRight = false;

    // for castling: to prevent the king from castling if any piece stands between the king and the rook
    preventCastlingIfPieceStandsBetweenRookAndKing(tappedPiece: tappedPiece, legalAndIllegalMoves: legalAndIllegalMoves);

    for (var square in legalAndIllegalMoves) {
      RelativeDirection relativeDirection = _getRelativeDirection(
          currentSquare: tappedPiece, targetSquare: square);

      if (tappedPiece.pieceType == null) {
        legalMoves.clear();
      } else if (tappedPiece.piece == Pieces.knight) {
        // treated differently than other pieces due to the way the knight moves
        (square.piece == null || square.pieceType != tappedPiece.pieceType)
            ? legalMoves.add(square)
            : null;
      } else if (square.piece == null) {
        switch (relativeDirection) {
          case RelativeDirection.rankLeft:
            if (!didCaptureOnRankLeft) {
              legalMoves.add(square);
            }
            break;
          case RelativeDirection.rankRight:
            if (!didCaptureOnRankRight) {
              legalMoves.add(square);
            }
            break;
          case RelativeDirection.fileTop:
            if (!didCaptureOnFileTop) {
              legalMoves.add(square);
            }
            break;
          case RelativeDirection.fileBottom:
            if (!didCaptureOnFileBottom) {
              legalMoves.add(square);
            }
            break;
          case RelativeDirection.diagonalTopLeft:
            if (!didCaptureOnDiagonalTopLeft) {
              legalMoves.add(square);
            }
            break;
          case RelativeDirection.diagonalTopRight:
            if (!didCaptureOnDiagonalTopRight) {
              legalMoves.add(square);
            }
            break;
          case RelativeDirection.diagonalBottomLeft:
            if (!didCaptureOnDiagonalBottomLeft) {
              legalMoves.add(square);
            }
            break;
          case RelativeDirection.diagonalBottomRight:
            if (!didCaptureOnDiagonalBottomRight) {
              legalMoves.add(square);
            }
            break;
          default:
            break;
        }
      } else {
        if (square.pieceType == tappedPiece.pieceType) {
          switch (relativeDirection) {
            case RelativeDirection.rankLeft:
              didCaptureOnRankLeft = true;
              break;
            case RelativeDirection.rankRight:
              didCaptureOnRankRight = true;

              break;
            case RelativeDirection.fileTop:
              didCaptureOnFileTop = true;

              break;
            case RelativeDirection.fileBottom:
              didCaptureOnFileBottom = true;

              break;
            case RelativeDirection.diagonalTopLeft:
              didCaptureOnDiagonalTopLeft = true;

              break;
            case RelativeDirection.diagonalTopRight:
              didCaptureOnDiagonalTopRight = true;

              break;
            case RelativeDirection.diagonalBottomLeft:
              didCaptureOnDiagonalBottomLeft = true;

              break;
            case RelativeDirection.diagonalBottomRight:
              didCaptureOnDiagonalBottomRight = true;

              break;
            default:
              break;
          }
        } else {
          switch (relativeDirection) {
            case RelativeDirection.rankLeft:
              if (!didCaptureOnRankLeft) {
                legalMoves.add(square);
                didCaptureOnRankLeft = true;
              }
              break;
            case RelativeDirection.rankRight:
              if (!didCaptureOnRankRight) {
                legalMoves.add(square);
                didCaptureOnRankRight = true;
              }
              break;
            case RelativeDirection.fileTop:
              if (!didCaptureOnFileTop) {
                legalMoves.add(square);
                didCaptureOnFileTop = true;
              }
              break;
            case RelativeDirection.fileBottom:
              if (!didCaptureOnFileBottom) {
                legalMoves.add(square);
                didCaptureOnFileBottom = true;
              }
              break;
            case RelativeDirection.diagonalTopLeft:
              if (!didCaptureOnDiagonalTopLeft) {
                legalMoves.add(square);
                didCaptureOnDiagonalTopLeft = true;
              }
              break;
            case RelativeDirection.diagonalTopRight:
              if (!didCaptureOnDiagonalTopRight) {
                legalMoves.add(square);
                didCaptureOnDiagonalTopRight = true;
              }
              break;
            case RelativeDirection.diagonalBottomLeft:
              if (!didCaptureOnDiagonalBottomLeft) {
                legalMoves.add(square);
                didCaptureOnDiagonalBottomLeft = true;
              }
              break;
            case RelativeDirection.diagonalBottomRight:
              if (!didCaptureOnDiagonalBottomRight) {
                legalMoves.add(square);
                didCaptureOnDiagonalBottomRight = true;
              }
              break;
            default:
              break;
          }
        }
      }
    }

    // filtering legal moves to prevent moving to a place that would not remove the check
    if(kingChecked){
      // in this step we place a piece on the legal moves square of the tapped piece and see if the king would still be checked or not.
      preventMovingIfCheckRemains(legalMoves: legalMoves, tappedPiece: tappedPiece);
    }

    filterMoveThatExposeKingToCheck(legalMoves, tappedPiece,fromHandleSquareTapped);

    return legalMoves;
  }

  void filterMoveThatExposeKingToCheck(List<Square> legalMoves, Square tappedPiece,bool fromHandleSquareTapped) {
  if(fromHandleSquareTapped){
    List<Square> legalMovesAttackingThePinningPiece= [];
    for (var move in legalMoves) {
      int moveIndex = chessBoard.indexOf(move);
      int tappedPieceIndex = chessBoard.indexWhere((square) => square.rank ==tappedPiece.rank && square.file == tappedPiece.file);
      //--------------------
      Square squareAtTappedIndex = chessBoard[tappedPieceIndex];
      Square squareAtMoveIndex = chessBoard[moveIndex];

      // emptying the square we are at currently
      chessBoard[tappedPieceIndex] = Square(piece:null,pieceType: null, file: squareAtTappedIndex.file,rank: squareAtTappedIndex.rank);

      chessBoard[moveIndex] = Square(piece:squareAtTappedIndex.piece,pieceType: squareAtTappedIndex.pieceType, file: squareAtMoveIndex.file,rank:squareAtMoveIndex.rank);
      // here we are checking if the escape square is attacked instead of the tapped square in case the tapped piece is a king, because here we are hypothetically moving a king not another piece
      bool  isKingAttacked = isKingSquareAttacked(playingTurn: tappedPiece.pieceType ==PieceType.light?PlayingTurn.white:PlayingTurn.black,escapeSquare:tappedPiece.piece ==Pieces.king? chessBoard[moveIndex] :null);
      // resetting the hypothetically moved pieces
      chessBoard[moveIndex] = squareAtMoveIndex;
      chessBoard[tappedPieceIndex] = squareAtTappedIndex;
      isKingAttacked?  null: legalMovesAttackingThePinningPiece.add(move);
    }
    legalMoves.clear();
    legalMoves.addAll(legalMovesAttackingThePinningPiece);
  }
  }

  void preventMovingIfCheckRemains({required List<Square> legalMoves, required Square tappedPiece}) {
     // in this step we place a piece on the legal moves square of the tapped piece and see if the king would still be checked or not.
    List<int> legalMovesIndices = [];
    for (var move in legalMoves) {
      int squareIndex = chessBoard.indexOf(move);
      if (squareIndex >= 0 && squareIndex <= 63) {
        legalMovesIndices.add(squareIndex);
      }
    }
    for(var index in legalMovesIndices){
      Square currentSquareAtIndex = chessBoard[index];

      chessBoard[index] = Square(piece:tappedPiece.piece,file: chessBoard[index].file,pieceType: tappedPiece.pieceType,rank: chessBoard[index].rank);
      // here we are checking if the escape square is attacked instead of the tapped square in case the tapped piece is a king, because here we are hypothetically moving a king not another piece
      bool  isKingAttacked = isKingSquareAttacked(playingTurn: tappedPiece.pieceType ==PieceType.light?PlayingTurn.white:PlayingTurn.black,escapeSquare:tappedPiece.piece ==Pieces.king? chessBoard[index] :null);
      if(isKingAttacked){
         legalMoves.removeWhere((move) => move.file ==chessBoard[index].file &&move.rank ==chessBoard[index].rank);
      }
      // resetting the hypothetically moved piece
      chessBoard[index] = currentSquareAtIndex;
    }
  }

  void preventCastlingIfPieceStandsBetweenRookAndKing(
      {required Square tappedPiece,required  List<Square> legalAndIllegalMoves}) {
       if (tappedPiece.piece == Pieces.king) {
      if (tappedPiece.pieceType == PieceType.light) {
        if (!didLightKingMove) {
          if (chessBoard[5].piece != null || chessBoard[6].piece != null) {
            legalAndIllegalMoves.removeWhere(
              (square) => (square.file == Files.g && square.rank == 1),
            );
          }
          if (chessBoard[1].piece != null ||
              chessBoard[2].piece != null ||
              chessBoard[3].piece != null) {
            legalAndIllegalMoves.removeWhere(
              (square) => (square.file == Files.c && square.rank == 1),
            );
          }
        }
      } else {
        if (!didDarkKingMove) {
          if (chessBoard[61].piece != null || chessBoard[62].piece != null) {
            legalAndIllegalMoves.removeWhere(
              (square) => (square.file == Files.g && square.rank == 8),
            );
          }
          if (chessBoard[57].piece != null ||
              chessBoard[58].piece != null ||
              chessBoard[59].piece != null) {
            legalAndIllegalMoves.removeWhere(
              (square) => (square.file == Files.c && square.rank == 8),
            );
          }
        }
      }
    }
  }

//-------------------------------------
  RelativeDirection _getRelativeDirection(
      {required Square targetSquare, required Square currentSquare}) {
    int currentSquareRank = currentSquare.rank;
    int targetSquareRank = targetSquare.rank;
    Files currentSquareFile = currentSquare.file;
    Files targetSquareFile = targetSquare.file;
    RelativeDirection relativeDirection;
    if (targetSquareRank == currentSquareRank) {
      relativeDirection = targetSquareFile.index > currentSquareFile.index
          ? RelativeDirection.rankRight
          : RelativeDirection.rankLeft;
    } else if (targetSquareFile == currentSquareFile) {
      relativeDirection = targetSquareRank > currentSquareRank
          ? RelativeDirection.fileTop
          : RelativeDirection.fileBottom;
    } else if (targetSquareFile.index > currentSquareFile.index) {
      relativeDirection = targetSquareRank > currentSquareRank
          ? RelativeDirection.diagonalTopRight
          : RelativeDirection.diagonalBottomRight;
    } else if (targetSquareFile.index < currentSquareFile.index) {
      relativeDirection = targetSquareRank > currentSquareRank
          ? RelativeDirection.diagonalTopLeft
          : RelativeDirection.diagonalBottomLeft;
    } else {
      relativeDirection = RelativeDirection.undefined;
    }
    return relativeDirection;
  }

  List<int> _getLegalMovesIndices(
      {required Files tappedSquareFile,
      required int tappedSquareRank,
        bool isKingChecked = false,
        bool fromHandleSquareTapped =false,
}) {
    List<Square> legalAndIllegalMoves = _getIllegalAndLegalMoves(
        rank: tappedSquareRank, file: tappedSquareFile);
    List<Square> legalMovesOnly = _getLegalMovesOnly(
        file: tappedSquareFile,
        rank: tappedSquareRank,
        legalAndIllegalMoves: legalAndIllegalMoves,
      fromHandleSquareTapped: fromHandleSquareTapped,
      kingChecked: isKingChecked
    );
    List<int> legalMovesIndices = [];
    for (var square in legalMovesOnly) {
      int squareIndex = chessBoard.indexOf(square);
      if (squareIndex >= 0 && squareIndex <= 63) {
        legalMovesIndices.add(squareIndex);
      }
    }

    return legalMovesIndices;
  }

  ///---------------------------------------------Checking Game Status-----------------------------------
  bool doesOnlyOneKingExists() {
    int kingsCount = 0;
    for (var element in chessBoard) {
      if (element.piece == Pieces.king) {
        kingsCount++;
      }
    }
    return kingsCount == 1;
  }

  bool doesAnyPlayerHaveMoreThanOneKing() {
    int whiteKingsCount = 0;
    int blackKingsCount = 0;
    for (var element in chessBoard) {
      if (element.piece == Pieces.king) {
        element.pieceType == PieceType.light
            ? whiteKingsCount++
            : blackKingsCount++;
      }
    }
    return whiteKingsCount > 1 || blackKingsCount > 1;
  }

  bool isAnyKingAdjacentToAnotherKing() {
    for (var element in chessBoard) {
      if (element.piece == Pieces.king) {
        List<Square> surroundingPieces =
            _getKingPieces(rank: element.rank, file: element.file);
        for (var square in surroundingPieces) {
          if (square.piece == Pieces.king) {
            return true;
          }
        }
      }
    }
    return false;
  }

  bool isKingSquareAttacked(
      {required PlayingTurn playingTurn, Square? escapeSquare}) {
    PieceType enemyKingType =
        playingTurn == PlayingTurn.white ? PieceType.light : PieceType.dark;
    Square enemyKingPiece = escapeSquare ??
        chessBoard.firstWhere((square) =>
            square.piece == Pieces.king && square.pieceType == enemyKingType);

    /// -------------------------------------getting surrounding enemy pawns--------------------------
    List<Square> surroundingEnemyPawns =
        _getPawnPieces(rank: enemyKingPiece.rank, file: enemyKingPiece.file);
    // pawns can't check a king of the same type
    surroundingEnemyPawns
        .removeWhere((pawn) => pawn.pieceType == enemyKingPiece.pieceType);
    // pawns that are on the same file as the king aren't checking the king
    surroundingEnemyPawns
        .removeWhere((pawn) => pawn.file == enemyKingPiece.file);
    surroundingEnemyPawns.removeWhere((pawn) {
      // a black king can't be put in check by white pawns higher in rank
      if (enemyKingPiece.pieceType == PieceType.dark &&
          pawn.rank > enemyKingPiece.rank) {
        return true;
      }
      // a white king can't be put in check by white pawns lower in rank
      if (enemyKingPiece.pieceType == PieceType.light &&
          pawn.rank < enemyKingPiece.rank) {
        return true;
      }
      return false;
    });

    /// -------------------------------------getting surrounding enemy knights---------------
    List<Square> surroundingKnights =
        _getKnightPieces(rank: enemyKingPiece.rank, file: enemyKingPiece.file);
    // knights of the same type as the enemy king can't check the king
    surroundingKnights
        .removeWhere((knight) => knight.pieceType == enemyKingPiece.pieceType);
    // empty squares don't count, same for pieces that are not knights
    surroundingKnights.removeWhere(
        (square) => square.piece == null || square.piece != Pieces.knight);

    /// ------------------------------------getting surrounding enemy rooks and queens  (queens vertical/horizontal to the enemy king)---------
    List<Square> surroundingRooksAndQueens = [
      ..._getHorizontalPieces(
          rank: enemyKingPiece.rank, file: enemyKingPiece.file),
      ..._getVerticalPieces(
          rank: enemyKingPiece.rank, file: enemyKingPiece.file),
    ];
    List<Square> surroundingRooksAndQueensInLineOfSight = _getLegalMovesOnly(
        legalAndIllegalMoves: surroundingRooksAndQueens,
        file: enemyKingPiece.file,
        rank: enemyKingPiece.rank);
    // rooks or queens of the same type as the king can't check the king
    surroundingRooksAndQueensInLineOfSight.removeWhere(
        (rookOrQueen) => rookOrQueen.pieceType == enemyKingPiece.pieceType);
    // empty squares don't count, same for pieces that are neither rooks nor queens
    surroundingRooksAndQueensInLineOfSight.removeWhere((square) =>
        square.piece == null ||
        (square.piece != Pieces.rook && square.piece != Pieces.queen));

    /// ----------------------------------------getting surrounding enemy bishops and queens (queens diagonal to the enemy king)----------------
    List<Square> surroundingBishopsAndQueens = _getDiagonalPieces(
        rank: enemyKingPiece.rank, file: enemyKingPiece.file);
    List<Square> surroundingBishopsAndQueensInLineOfSight = _getLegalMovesOnly(
        legalAndIllegalMoves: surroundingBishopsAndQueens,
        file: enemyKingPiece.file,
        rank: enemyKingPiece.rank);
    surroundingBishopsAndQueensInLineOfSight.removeWhere(
        (bishopOrQueen) => bishopOrQueen.pieceType == enemyKingPiece.pieceType);
    // empty squares don't count, same for pieces that are neither bishops nor queens
    surroundingBishopsAndQueensInLineOfSight.removeWhere((square) =>
        square.piece == null ||
        (square.piece != Pieces.bishop && square.piece != Pieces.queen));

    ///------------------------------------------------------------------------------------

    return surroundingEnemyPawns.isNotEmpty ||
        surroundingKnights.isNotEmpty ||
        surroundingRooksAndQueensInLineOfSight.isNotEmpty ||
        surroundingBishopsAndQueensInLineOfSight.isNotEmpty;
  }

  bool isCheckmate( {required PlayingTurn attackedPlayer}){
    List<int> movesThatProtectTheKing = [];
    // a late initialization error should not occur, unless the logic is wrong
    late Square kingSquare;

      // find all the attacked player pieces expect the king
      // find all the legal moves for those pieces
      // move them and check if king is still attacked
      PieceType attackedPlayerType = attackedPlayer == PlayingTurn.white? PieceType.light:PieceType.dark;
      List<Square>  attackedPlayerPieces =[];
      for (var square in chessBoard) {
        if(square.pieceType == attackedPlayerType){
          if(square.piece == Pieces.king ){
            kingSquare =square;
          }else{
            attackedPlayerPieces.add(square);
          }
        }
      }
      List<Square> attackedPlayerLegalMoves = [];
      List<int> attackedPlayerLegalMovesIndices = [];
      for(var piece in attackedPlayerPieces){
      List<Square> legalAndIllegalMoves = _getIllegalAndLegalMoves(rank: piece.rank, file: piece.file);
      List<Square> legalMovesOnly = _getLegalMovesOnly(legalAndIllegalMoves: legalAndIllegalMoves, file: piece.file, rank: piece.rank);
      List<int> legalMovesIndices = _getLegalMovesIndices(tappedSquareFile: piece.file, tappedSquareRank: piece.rank);
          attackedPlayerLegalMoves.addAll(legalMovesOnly);
      attackedPlayerLegalMovesIndices.addAll(legalMovesIndices);
      }

    movesThatProtectTheKing.addAll(attackedPlayerLegalMovesIndices);


    for(var index in attackedPlayerLegalMovesIndices){
      Square currentSquareAtIndex =chessBoard[index];
      // deep copy
      chessBoard[index] = Square(
        file: chessBoard[index].file,
        rank: chessBoard[index].rank,piece: Pieces.pawn,
         pieceType: attackedPlayerType,
      );
      if(isKingSquareAttacked(playingTurn: attackedPlayer)){
        movesThatProtectTheKing.removeWhere((moveIndex) => moveIndex == index);

      }
      chessBoard[index] = currentSquareAtIndex;
    }



    ///-----------------------------checking if king can move to safety
    List<int> kingLegalMovesIndices = _getLegalMovesIndices(tappedSquareFile: kingSquare.file, tappedSquareRank: kingSquare.rank);

    List<int> kingMovesThatWouldProtectHim =[];
    kingMovesThatWouldProtectHim.addAll(kingLegalMovesIndices);
    for(var index in kingLegalMovesIndices){
      Square currentSquare = Square(file: chessBoard[index].file, rank: chessBoard[index].rank, piece: chessBoard[index].piece, pieceType: chessBoard[index].pieceType);
        chessBoard[index]=Square(file:  chessBoard[index].file, rank: chessBoard[index].rank, piece: Pieces.king, pieceType: attackedPlayerType);
      if(isKingSquareAttacked(playingTurn: attackedPlayer)){
          kingMovesThatWouldProtectHim.removeWhere((moveIndex) => moveIndex ==index);
      }
        chessBoard[index] = currentSquare;
    }
    return kingMovesThatWouldProtectHim.isEmpty && movesThatProtectTheKing.isEmpty;
  }
}

class Square {
  Files file;
  int rank;
  Pieces? piece;
  PieceType? pieceType;

  Square({
    required this.file,
    required this.rank,
    required this.piece,
    required this.pieceType,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Square &&
          file == other.file &&
          rank == other.rank &&
          piece == other.piece &&
          pieceType == other.pieceType;
}

bool _isValidFen({required fenString}) {
  return true;
}
