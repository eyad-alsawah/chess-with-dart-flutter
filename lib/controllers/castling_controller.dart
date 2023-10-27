import 'package:chess/controllers/enums.dart';
import 'package:chess/controllers/game_controller.dart';
import 'package:chess/model/global_state.dart';
import 'package:chess/model/model.dart';

class CastlingController {
  // Private constructor
  CastlingController._private();

  // Private static instance
  static final CastlingController _instance = CastlingController._private();

  // Public static method to access the instance
  static CastlingController get instance => _instance;
  //----------------------------------------------------------------------------
  List<Square> getCastlingAvailability({required PieceType pieceType}) {
    List<Square> castlingAvailability;
    if (pieceType == PieceType.light) {
      if (sharedState.didLightKingMove) {
        castlingAvailability = [];
      } else if (sharedState.didLightKingSideRookMove) {
        castlingAvailability =
            sharedState.didLightQueenSideRookMove ? [] : [chessBoard[2]];
      } else {
        castlingAvailability = sharedState.didLightQueenSideRookMove
            ? [chessBoard[6]]
            : [chessBoard[2], chessBoard[6]];
      }
    } else {
      if (sharedState.didDarkKingMove) {
        castlingAvailability = [];
      } else if (sharedState.didDarkKingSideRookMove) {
        castlingAvailability =
            sharedState.didDarkQueenSideRookMove ? [] : [chessBoard[58]];
      } else {
        castlingAvailability = sharedState.didDarkQueenSideRookMove
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
          chessBoard[63].piece = null;
          chessBoard[63].pieceType = null;
          chessBoard[61].piece = Pieces.rook;
          chessBoard[61].pieceType = PieceType.dark;
        } else {
          callbacks.onPieceMoved(56, 59);
          chessBoard[56].piece = null;
          chessBoard[56].pieceType = null;
          chessBoard[59].piece = Pieces.rook;
          chessBoard[59].pieceType = PieceType.dark;
        }
      } else if (sharedState.selectedPiece?.pieceType == PieceType.light &&
          sharedState.selectedPieceIndex! == 4 &&
          (tappedSquareIndex == 2 || tappedSquareIndex == 6)) {
        if (tappedSquareIndex == 6) {
          callbacks.onPieceMoved(7, 5);
          chessBoard[7].piece = null;
          chessBoard[7].pieceType = null;
          chessBoard[5].piece = Pieces.rook;
          chessBoard[5].pieceType = PieceType.light;
        } else {
          callbacks.onPieceMoved(0, 3);
          chessBoard[0].piece = null;
          chessBoard[0].pieceType = null;
          chessBoard[3].piece = Pieces.rook;
          chessBoard[3].pieceType = PieceType.light;
        }
      }
    }
  }
}
