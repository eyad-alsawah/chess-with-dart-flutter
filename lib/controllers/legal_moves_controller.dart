import 'package:chess/controllers/enums.dart';
import 'package:chess/controllers/helper_methods.dart';
import 'package:chess/controllers/shared_state.dart';
import 'package:chess/model/global_state.dart';
import 'package:chess/model/chess_board_model.dart';

import 'package:chess/model/square.dart';
import 'package:chess/utils/debug_config.dart';
import 'package:chess/utils/extensions.dart';
import 'package:chess/utils/index_to_square_map.dart';

class LegalMovesController {
  // Private constructor
  LegalMovesController._private();

  // Private static instance
  static final LegalMovesController _instance = LegalMovesController._private();

  // Public static method to access the instance
  static LegalMovesController get instance => _instance;
  //----------------------------------------------------------------------------

  Future<List<int>> getLegalMovesIndices({
    required Files tappedSquareFile,
    required int tappedSquareRank,
    bool isKingChecked = false,
    bool fromHandleSquareTapped = false,
  }) async {
    // getting all the moves a piece can move to if there was nothing standing in its way
    List<Square> legalAndIllegalMoves =
        getIllegalAndLegalMoves(rank: tappedSquareRank, file: tappedSquareFile);

    if (DebugConfig.displayAllLegalAndIllegalMoves) {
      SharedState.instance.debugHighlightIndices.clear();
      SharedState.instance.debugHighlightIndices.addAll(
          HelperMethods.instance.squaresToIndices(legalAndIllegalMoves));
    } else {
      SharedState.instance.debugHighlightIndices.clear();
    }

    // filtering out illegal moves
    List<Square> legalMovesOnly = await getLegalMovesOnly(
        file: tappedSquareFile,
        rank: tappedSquareRank,
        legalAndIllegalMoves: legalAndIllegalMoves.deepCopy(),
        fromHandleSquareTapped: fromHandleSquareTapped,
        kingChecked: isKingChecked);

    return HelperMethods.instance.squaresToIndices(legalMovesOnly);
  }

  //----------------------------------------------------------------------------------

  Future<List<Square>> getLegalMovesOnly(
      {required List<Square> legalAndIllegalMoves,
      required Files file,
      required int rank,
      bool fromHandleSquareTapped = false,
      bool kingChecked = false}) async {
    List<Square> legalMoves = [];
    Square tappedPiece =
        ChessBoardModel.getSquareAtFileAndRank(file: file, rank: rank);

    bool didCaptureOnRankLeft = false;
    bool didCaptureOnRankRight = false;
    bool didCaptureOnFileTop = false;
    bool didCaptureOnFileBottom = false;
    bool didCaptureOnDiagonalTopLeft = false;
    bool didCaptureOnDiagonalTopRight = false;
    bool didCaptureOnDiagonalBottomLeft = false;
    bool didCaptureOnDiagonalBottomRight = false;

    // for castling: to prevent the king from castling if any piece stands between the king and the rook
    legalAndIllegalMoves = preventCastlingIfPieceStandsBetweenRookAndKing(
        tappedPiece: tappedPiece.copy(),
        legalAndIllegalMoves: legalAndIllegalMoves.deepCopy());

    for (var move in legalAndIllegalMoves) {
      RelativeDirection relativeDirection = helperMethods.getRelativeDirection(
          currentSquare: tappedPiece, targetSquare: move);

      if (tappedPiece.pieceType == null) {
        legalMoves.clear();
      } else if (tappedPiece.piece == Pieces.knight) {
        // treated differently than other pieces due to the way the knight moves
        (move.piece == null || move.pieceType != tappedPiece.pieceType)
            ? legalMoves.add(move)
            : null;
      } else if (move.piece == null) {
        switch (relativeDirection) {
          case RelativeDirection.rankLeft:
            if (!didCaptureOnRankLeft) {
              legalMoves.add(move);
            }
            break;
          case RelativeDirection.rankRight:
            if (!didCaptureOnRankRight) {
              legalMoves.add(move);
            }
            break;
          case RelativeDirection.fileTop:
            if (!didCaptureOnFileTop) {
              legalMoves.add(move);
            }
            break;
          case RelativeDirection.fileBottom:
            if (!didCaptureOnFileBottom) {
              legalMoves.add(move);
            }
            break;
          case RelativeDirection.diagonalTopLeft:
            if (!didCaptureOnDiagonalTopLeft) {
              legalMoves.add(move);
            }
            break;
          case RelativeDirection.diagonalTopRight:
            if (!didCaptureOnDiagonalTopRight) {
              legalMoves.add(move);
            }
            break;
          case RelativeDirection.diagonalBottomLeft:
            if (!didCaptureOnDiagonalBottomLeft) {
              legalMoves.add(move);
            }
            break;
          case RelativeDirection.diagonalBottomRight:
            if (!didCaptureOnDiagonalBottomRight) {
              legalMoves.add(move);
            }
            break;
          default:
            break;
        }
      } else {
        if (move.pieceType == tappedPiece.pieceType) {
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
                legalMoves.add(move);
                didCaptureOnRankLeft = true;
              }
              break;
            case RelativeDirection.rankRight:
              if (!didCaptureOnRankRight) {
                legalMoves.add(move);
                didCaptureOnRankRight = true;
              }
              break;
            case RelativeDirection.fileTop:
              if (!didCaptureOnFileTop) {
                legalMoves.add(move);
                didCaptureOnFileTop = true;
              }
              break;
            case RelativeDirection.fileBottom:
              if (!didCaptureOnFileBottom) {
                legalMoves.add(move);
                didCaptureOnFileBottom = true;
              }
              break;
            case RelativeDirection.diagonalTopLeft:
              if (!didCaptureOnDiagonalTopLeft) {
                legalMoves.add(move);
                didCaptureOnDiagonalTopLeft = true;
              }
              break;
            case RelativeDirection.diagonalTopRight:
              if (!didCaptureOnDiagonalTopRight) {
                legalMoves.add(move);
                didCaptureOnDiagonalTopRight = true;
              }
              break;
            case RelativeDirection.diagonalBottomLeft:
              if (!didCaptureOnDiagonalBottomLeft) {
                legalMoves.add(move);
                didCaptureOnDiagonalBottomLeft = true;
              }
              break;
            case RelativeDirection.diagonalBottomRight:
              if (!didCaptureOnDiagonalBottomRight) {
                legalMoves.add(move);
                didCaptureOnDiagonalBottomRight = true;
              }
              break;
            default:
              break;
          }
        }
      }
    }
    print("--------------------");

    // filtering legal moves to prevent moving to a place that would not remove the check
    if (kingChecked) {
      // in this step we place a piece on the legal moves square of the tapped piece and see if the king would still be checked or not.
      legalMoves = await preventMovingIfCheckRemains(
          legalMoves: legalMoves.deepCopy(), tappedPiece: tappedPiece.copy());
    }
    // todo: causing problems needs fixing
    legalMoves = await filterMoveThatExposeKingToCheck(
        legalMoves.deepCopy(), tappedPiece.copy(), fromHandleSquareTapped);

    return legalMoves.deepCopy();
  }

  Future<List<Square>> filterMoveThatExposeKingToCheck(List<Square> legalMoves,
      Square selectedPiece, bool fromHandleSquareTapped) async {
    if (fromHandleSquareTapped) {
      // deep copying the list to prevent Concurrent modification of legalMoves
      for (var move in legalMoves.deepCopy()) {
        int moveIndex = ChessBoardModel.getIndexOfSquare(move);
        PieceType? moveType = move.copy().pieceType;
        Pieces? movePiece = move.copy().piece;

        int selectedPieceIndex = ChessBoardModel.getIndexOfSquareAtFileAndRank(
            file: selectedPiece.file, rank: selectedPiece.rank);
        //--------------------

        // emptying the square we are at currently
        await ChessBoardModel.emptySquareAtIndex(selectedPieceIndex);

        // updating the square at moveIndex
        await ChessBoardModel.updateSquareAtIndex(
          moveIndex,
          selectedPiece.piece,
          selectedPiece.pieceType,
        );

        // here we are checking if the escape square is attacked instead of the tapped square in case the tapped piece is a king, because here we are hypothetically moving a king not another piece
        bool isKingAttacked = await gameStatusController.isKingSquareAttacked(
            playingTurn: selectedPiece.pieceType == PieceType.light
                ? PlayingTurn.white
                : PlayingTurn.black,
            escapeSquare: selectedPiece.piece == Pieces.king ? move : null);

        // resetting the hypothetically moved pieces
        await ChessBoardModel.updateSquareAtIndex(
            selectedPieceIndex, selectedPiece.piece, selectedPiece.pieceType);
        await ChessBoardModel.updateSquareAtIndex(
            moveIndex, movePiece, moveType);
        isKingAttacked ? legalMoves.remove(move) : null;
      }
    }

    return legalMoves;
  }

  Future<void> updateViewAndWait() async {
    callbacks.updateView();
    await Future.delayed(const Duration(milliseconds: 2000));
    callbacks.updateView();
  }

  Future<List<Square>> preventMovingIfCheckRemains(
      {required List<Square> legalMoves, required Square tappedPiece}) async {
    // in this step we place a piece on the legal moves square of the tapped piece and see if the king would still be checked or not.
    List<int> legalMovesIndices = [];

    legalMovesIndices
        .addAll(HelperMethods.instance.squaresToIndices(legalMoves.deepCopy()));

    for (var index in legalMovesIndices) {
      Square currentSquareAtIndex =
          ChessBoardModel.getSquareAtIndex(index).copy();

      ChessBoardModel.updateSquareAtIndex(
          index, tappedPiece.piece, tappedPiece.pieceType);

      // here we are checking if the escape square is attacked instead of the tapped square in case the tapped piece is a king, because here we are hypothetically moving a king not another piece
      bool isKingAttacked = await gameStatusController.isKingSquareAttacked(
          playingTurn: tappedPiece.pieceType == PieceType.light
              ? PlayingTurn.white
              : PlayingTurn.black,
          escapeSquare: tappedPiece.piece == Pieces.king
              ? ChessBoardModel.getSquareAtIndex(index).copy()
              : null);
      if (isKingAttacked) {
        legalMoves.removeWhere((move) =>
            move.file == ChessBoardModel.getSquareAtIndex(index).copy().file &&
            move.rank == ChessBoardModel.getSquareAtIndex(index).copy().rank);
      }
      // resetting the hypothetically moved piece
      ChessBoardModel.updateSquareAtIndex(
          index, currentSquareAtIndex.piece, currentSquareAtIndex.pieceType);
    }

    return legalMoves;
  }

  List<Square> preventCastlingIfPieceStandsBetweenRookAndKing(
      {required Square tappedPiece,
      required List<Square> legalAndIllegalMoves}) {
    if (tappedPiece.piece == Pieces.king) {
      if (tappedPiece.pieceType == PieceType.light) {
        if (!sharedState.didLightKingMove) {
          if (ChessBoardModel.getSquareAtIndex(ChessSquare.f1.index).piece !=
                  null ||
              ChessBoardModel.getSquareAtIndex(ChessSquare.g1.index).piece !=
                  null) {
            legalAndIllegalMoves.removeWhere(
              (square) => (square.file == Files.g && square.rank == 1),
            );
          }
          if (ChessBoardModel.getSquareAtIndex(
                          ChessSquare.b1.index)
                      .piece !=
                  null ||
              ChessBoardModel.getSquareAtIndex(ChessSquare.c1.index).piece !=
                  null ||
              ChessBoardModel.getSquareAtIndex(ChessSquare.d1.index).piece !=
                  null) {
            legalAndIllegalMoves.removeWhere(
              (square) => (square.file == Files.c && square.rank == 1),
            );
          }
        }
      } else {
        if (!sharedState.didDarkKingMove) {
          if (ChessBoardModel.getSquareAtIndex(ChessSquare.f8.index).piece !=
                  null ||
              ChessBoardModel.getSquareAtIndex(ChessSquare.g8.index).piece !=
                  null) {
            legalAndIllegalMoves.removeWhere(
              (square) => (square.file == Files.g && square.rank == 8),
            );
          }
          if (ChessBoardModel.getSquareAtIndex(
                          ChessSquare.b8.index)
                      .piece !=
                  null ||
              ChessBoardModel.getSquareAtIndex(ChessSquare.c8.index).piece !=
                  null ||
              ChessBoardModel.getSquareAtIndex(ChessSquare.d8.index).piece !=
                  null) {
            legalAndIllegalMoves.removeWhere(
              (square) => (square.file == Files.c && square.rank == 8),
            );
          }
        }
      }
    }
    return legalAndIllegalMoves;
  }

  //----------------------------------------------------------------------------

  List<Square> getIllegalAndLegalMoves(
      {required int rank, required Files file}) {
    Square tappedPiece =
        ChessBoardModel.getSquareAtFileAndRank(file: file, rank: rank);

    List<Square> moves = [];

    // Define a map to associate each piece type with its move calculation function
    final Map<Pieces, List<Square> Function()> moveFunctions = {
      Pieces.rook: () =>
          basicMovesController.getHorizontalPieces(rank: rank, file: file) +
          basicMovesController.getVerticalPieces(rank: rank, file: file),
      Pieces.knight: () =>
          basicMovesController.getKnightPieces(rank: rank, file: file),
      Pieces.bishop: () =>
          basicMovesController.getDiagonalPieces(rank: rank, file: file),
      Pieces.queen: () =>
          basicMovesController.getHorizontalPieces(rank: rank, file: file) +
          basicMovesController.getVerticalPieces(rank: rank, file: file) +
          basicMovesController.getDiagonalPieces(rank: rank, file: file),
      Pieces.king: () =>
          basicMovesController.getKingPieces(rank: rank, file: file),
      Pieces.pawn: () =>
          basicMovesController.getPawnPieces(rank: rank, file: file),
    };

    // Use the map to get the corresponding moves for the tapped piece
    moves = moveFunctions[tappedPiece.piece]?.call() ?? [];

    return moves;
  }
}
