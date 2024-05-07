import 'package:chess/controllers/enums.dart';
import 'package:chess/model/global_state.dart';
import 'package:chess/model/model.dart';
import 'package:chess/model/square.dart';
import 'package:chess/utils/index_to_square_map.dart';

class CastlingController {
  // Private constructor
  CastlingController._private();

  // Private static instance
  static final CastlingController _instance = CastlingController._private();

  // Public static method to access the instance
  static CastlingController get instance => _instance;
  //----------------------------------------------------------------------------
  // todo: handle cases where there aren't rooks on the start of the game
  List<Square> getCastlingAvailability({required PieceType pieceType}) {
    List<Square> castlingAvailability;
    if (pieceType == PieceType.light) {
      if (sharedState.didLightKingMove) {
        castlingAvailability = [];
      } else if (sharedState.didLightKingSideRookMove) {
        castlingAvailability = sharedState.didLightQueenSideRookMove
            ? []
            : [chessBoard[ChessSquare.c1.index]];
      } else {
        castlingAvailability = sharedState.didLightQueenSideRookMove
            ? [chessBoard[ChessSquare.g6.index]]
            : [
                chessBoard[ChessSquare.c1.index],
                chessBoard[ChessSquare.g1.index]
              ];
      }
    } else {
      if (sharedState.didDarkKingMove) {
        castlingAvailability = [];
      } else if (sharedState.didDarkKingSideRookMove) {
        castlingAvailability = sharedState.didDarkQueenSideRookMove
            ? []
            : [chessBoard[ChessSquare.c8.index]];
      } else {
        castlingAvailability = sharedState.didDarkQueenSideRookMove
            ? [chessBoard[ChessSquare.g8.index]]
            : [
                chessBoard[ChessSquare.c8.index],
                chessBoard[ChessSquare.g8.index]
              ];
      }
    }
    return castlingAvailability;
  }

  void changeCastlingAvailability(
      {required Pieces movedPiece,
      required PieceType movedPieceType,
      required int indexPieceMovedFrom}) {
    // checking if castling is possible in the first place before checking all the other conditions
    bool canWhiteKingCastle = !sharedState.didLightKingMove &&
        (!sharedState.didLightKingSideRookMove ||
            !sharedState.didLightQueenSideRookMove);
    bool canBlackKingCastle = !sharedState.didDarkKingMove &&
        (!sharedState.didDarkKingSideRookMove ||
            !sharedState.didDarkQueenSideRookMove);

    if (movedPieceType == PieceType.dark && !canBlackKingCastle) {
      return;
    }
    if (movedPieceType == PieceType.light && !canWhiteKingCastle) {
      return;
    }
    // todo: check castling availability on the start of the game by checking the existing pieces on the squares like the a1 and h8 for example
    if (movedPiece == Pieces.king) {
      if (movedPieceType == PieceType.light) {
        sharedState.didLightKingMove = true;
      } else {
        sharedState.didDarkKingMove = true;
      }
    } else if (movedPiece == Pieces.rook) {
      if (movedPieceType == PieceType.light) {
        if (indexPieceMovedFrom == 0) {
          sharedState.didLightQueenSideRookMove = true;
        } else if (indexPieceMovedFrom == 7) {
          sharedState.didLightKingSideRookMove = true;
        }
      } else {
        if (indexPieceMovedFrom == 56) {
          sharedState.didDarkQueenSideRookMove = true;
        } else if (indexPieceMovedFrom == 63) {
          sharedState.didDarkKingSideRookMove = true;
        }
      }
    }
  }

  void moveRookOnCastle({required int tappedSquareIndex}) {
    if (sharedState.selectedPiece?.piece == Pieces.king) {
      if (sharedState.selectedPiece?.pieceType == PieceType.dark &&
          sharedState.selectedPieceIndex! == 60 &&
          (tappedSquareIndex == 62 || tappedSquareIndex == 58)) {
        // moving the rook and updating the board
        if (tappedSquareIndex == 62) {
          callbacks.onPieceMoved(63, 61);
          chessBoard[ChessSquare.h8.index].piece = null;
          chessBoard[ChessSquare.h8.index].pieceType = null;
          chessBoard[ChessSquare.f8.index].piece = Pieces.rook;
          chessBoard[ChessSquare.f8.index].pieceType = PieceType.dark;
        } else {
          callbacks.onPieceMoved(56, 59);
          chessBoard[ChessSquare.a8.index].piece = null;
          chessBoard[ChessSquare.a8.index].pieceType = null;
          chessBoard[ChessSquare.d8.index].piece = Pieces.rook;
          chessBoard[ChessSquare.d8.index].pieceType = PieceType.dark;
        }
      } else if (sharedState.selectedPiece?.pieceType == PieceType.light &&
          sharedState.selectedPieceIndex! == 4 &&
          (tappedSquareIndex == 2 || tappedSquareIndex == 6)) {
        if (tappedSquareIndex == 6) {
          callbacks.onPieceMoved(7, 5);
          chessBoard[ChessSquare.h1.index].piece = null;
          chessBoard[ChessSquare.h1.index].pieceType = null;
          chessBoard[ChessSquare.f1.index].piece = Pieces.rook;
          chessBoard[ChessSquare.f1.index].pieceType = PieceType.light;
        } else {
          callbacks.onPieceMoved(0, 3);
          chessBoard[ChessSquare.a1.index].piece = null;
          chessBoard[ChessSquare.a1.index].pieceType = null;
          chessBoard[ChessSquare.d1.index].piece = Pieces.rook;
          chessBoard[ChessSquare.d1.index].pieceType = PieceType.light;
        }
      }
    }
  }
}
