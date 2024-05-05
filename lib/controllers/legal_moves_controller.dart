import 'package:chess/controllers/enums.dart';
import 'package:chess/model/global_state.dart';
import 'package:chess/model/model.dart';

import 'package:chess/model/square.dart';

class LegalMovesController {
  // Private constructor
  LegalMovesController._private();

  // Private static instance
  static final LegalMovesController _instance = LegalMovesController._private();

  // Public static method to access the instance
  static LegalMovesController get instance => _instance;
  //----------------------------------------------------------------------------

  List<int> getLegalMovesIndices({
    required Files tappedSquareFile,
    required int tappedSquareRank,
    bool isKingChecked = false,
    bool fromHandleSquareTapped = false,
  }) {
    List<Square> legalAndIllegalMoves =
        getIllegalAndLegalMoves(rank: tappedSquareRank, file: tappedSquareFile);
    List<Square> legalMovesOnly = getLegalMovesOnly(
        file: tappedSquareFile,
        rank: tappedSquareRank,
        legalAndIllegalMoves: legalAndIllegalMoves,
        fromHandleSquareTapped: fromHandleSquareTapped,
        kingChecked: isKingChecked);
    List<int> legalMovesIndices = [];
    for (var square in legalMovesOnly) {
      int squareIndex = chessBoard.indexOf(square);
      if (squareIndex >= 0 && squareIndex <= 63) {
        legalMovesIndices.add(squareIndex);
      }
    }

    return legalMovesIndices;
  }

  List<Square> getLegalMovesOnly(
      {required List<Square> legalAndIllegalMoves,
      required Files file,
      required int rank,
      bool fromHandleSquareTapped = false,
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
    preventCastlingIfPieceStandsBetweenRookAndKing(
        tappedPiece: tappedPiece, legalAndIllegalMoves: legalAndIllegalMoves);

    for (var square in legalAndIllegalMoves) {
      RelativeDirection relativeDirection = helperMethods.getRelativeDirection(
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
    if (kingChecked) {
      // in this step we place a piece on the legal moves square of the tapped piece and see if the king would still be checked or not.
      preventMovingIfCheckRemains(
          legalMoves: legalMoves, tappedPiece: tappedPiece);
    }

    filterMoveThatExposeKingToCheck(
        legalMoves, tappedPiece, fromHandleSquareTapped);

    return legalMoves;
  }

  void filterMoveThatExposeKingToCheck(List<Square> legalMoves,
      Square tappedPiece, bool fromHandleSquareTapped) {
    if (fromHandleSquareTapped) {
      List<Square> legalMovesAttackingThePinningPiece = [];
      for (var move in legalMoves) {
        int moveIndex = chessBoard.indexOf(move);
        int tappedPieceIndex = chessBoard.indexWhere((square) =>
            square.rank == tappedPiece.rank && square.file == tappedPiece.file);
        //--------------------
        Square squareAtTappedIndex = chessBoard[tappedPieceIndex];
        Square squareAtMoveIndex = chessBoard[moveIndex];

        // emptying the square we are at currently
        chessBoard[tappedPieceIndex] = Square(
            piece: null,
            pieceType: null,
            file: squareAtTappedIndex.file,
            rank: squareAtTappedIndex.rank);

        chessBoard[moveIndex] = Square(
            piece: squareAtTappedIndex.piece,
            pieceType: squareAtTappedIndex.pieceType,
            file: squareAtMoveIndex.file,
            rank: squareAtMoveIndex.rank);
        // here we are checking if the escape square is attacked instead of the tapped square in case the tapped piece is a king, because here we are hypothetically moving a king not another piece
        bool isKingAttacked = gameStatusController.isKingSquareAttacked(
            playingTurn: tappedPiece.pieceType == PieceType.light
                ? PlayingTurn.white
                : PlayingTurn.black,
            escapeSquare: tappedPiece.piece == Pieces.king
                ? chessBoard[moveIndex]
                : null);
        // resetting the hypothetically moved pieces
        chessBoard[moveIndex] = squareAtMoveIndex;
        chessBoard[tappedPieceIndex] = squareAtTappedIndex;
        isKingAttacked ? null : legalMovesAttackingThePinningPiece.add(move);
      }
      legalMoves.clear();
      legalMoves.addAll(legalMovesAttackingThePinningPiece);
    }
  }

  void preventMovingIfCheckRemains(
      {required List<Square> legalMoves, required Square tappedPiece}) {
    // in this step we place a piece on the legal moves square of the tapped piece and see if the king would still be checked or not.
    List<int> legalMovesIndices = [];
    for (var move in legalMoves) {
      int squareIndex = chessBoard.indexOf(move);
      if (squareIndex >= 0 && squareIndex <= 63) {
        legalMovesIndices.add(squareIndex);
      }
    }
    for (var index in legalMovesIndices) {
      Square currentSquareAtIndex = chessBoard[index];

      chessBoard[index] = Square(
          piece: tappedPiece.piece,
          file: chessBoard[index].file,
          pieceType: tappedPiece.pieceType,
          rank: chessBoard[index].rank);
      // here we are checking if the escape square is attacked instead of the tapped square in case the tapped piece is a king, because here we are hypothetically moving a king not another piece
      bool isKingAttacked = gameStatusController.isKingSquareAttacked(
          playingTurn: tappedPiece.pieceType == PieceType.light
              ? PlayingTurn.white
              : PlayingTurn.black,
          escapeSquare:
              tappedPiece.piece == Pieces.king ? chessBoard[index] : null);
      if (isKingAttacked) {
        legalMoves.removeWhere((move) =>
            move.file == chessBoard[index].file &&
            move.rank == chessBoard[index].rank);
      }
      // resetting the hypothetically moved piece
      chessBoard[index] = currentSquareAtIndex;
    }
  }

  void preventCastlingIfPieceStandsBetweenRookAndKing(
      {required Square tappedPiece,
      required List<Square> legalAndIllegalMoves}) {
    if (tappedPiece.piece == Pieces.king) {
      if (tappedPiece.pieceType == PieceType.light) {
        if (!sharedState.didLightKingMove) {
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
        if (!sharedState.didDarkKingMove) {
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

  //----------------------------------------------------------------------------

  List<Square> getIllegalAndLegalMoves(
      {required int rank, required Files file}) {
    Square tappedPiece = chessBoard
        .firstWhere((element) => element.rank == rank && element.file == file);

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
