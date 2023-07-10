import 'package:chess/utils/enums.dart';
import 'package:chess/controller/chess_controller.dart';
import 'package:chess/model/model.dart';

class CastlingController{
  //
  // static final CastlingController _singleton = CastlingController._internal();
  //
  // factory CastlingController() {
  //
  //   return _singleton;
  // }
  //
  // CastlingController._internal();
  //






  static bool didLightKingMove = false;
  static bool didDarkKingMove = false;
  static bool didLightKingSideRookMove = false;
  static bool didLightQueenSideRookMove = false;
  static bool didDarkKingSideRookMove = false;
  static bool didDarkQueenSideRookMove = false;
  void preventCastlingIfPieceStandsBetweenRookAndKing(
      {required Square tappedPiece,
        required List<Square> legalAndIllegalMoves}) {
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
}