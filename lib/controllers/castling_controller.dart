import 'package:chess/controllers/enums.dart';
import 'package:chess/controllers/shared_state.dart';
import 'package:chess/model/chess_board_model.dart';
import 'package:chess/model/global_state.dart';
import 'package:chess/utils/extensions.dart';

class CastlingController {
  // Private constructor
  CastlingController._private();

  // Private static instance
  static final CastlingController _instance = CastlingController._private();

  // Public static method to access the instance
  static CastlingController get instance => _instance;
  //----------------------------------------------------------------------------
  // todo: handle cases where there aren't rooks on the start of the game
  List<int> getCastlingAvailability({required PieceType pieceType}) {
    List<int> castlingAvailability;
    if (pieceType == PieceType.light) {
      if (SharedState.instance.didLightKingMove) {
        castlingAvailability = [];
      } else if (SharedState.instance.didLightKingSideRookMove) {
        castlingAvailability = SharedState.instance.didLightQueenSideRookMove
            ? []
            : [ChessSquare.c1.index];
      } else {
        castlingAvailability = SharedState.instance.didLightQueenSideRookMove
            ? [ChessSquare.g6.index]
            : [ChessSquare.c1.index, ChessSquare.g1.index];
      }
    } else {
      if (SharedState.instance.didDarkKingMove) {
        castlingAvailability = [];
      } else if (SharedState.instance.didDarkKingSideRookMove) {
        castlingAvailability =
            sharedState.didDarkQueenSideRookMove ? [] : [ChessSquare.c8.index];
      } else {
        castlingAvailability = SharedState.instance.didDarkQueenSideRookMove
            ? [ChessSquare.g8.index]
            : [ChessSquare.c8.index, ChessSquare.g8.index];
      }
    }
    return castlingAvailability;
  }

  void changeCastlingAvailability({required int from}) {
    PieceType fromSquarePieceType = from.type()!;
    Pieces fromSquarePiece = from.piece()!;
    // checking if castling is possible in the first place before checking all the other conditions
    bool canWhiteKingCastle = !SharedState.instance.didLightKingMove &&
        (!SharedState.instance.didLightKingSideRookMove ||
            !SharedState.instance.didLightQueenSideRookMove);
    bool canBlackKingCastle = !SharedState.instance.didDarkKingMove &&
        (!SharedState.instance.didDarkKingSideRookMove ||
            !SharedState.instance.didDarkQueenSideRookMove);

    if (fromSquarePieceType == PieceType.dark && !canBlackKingCastle) {
      return;
    }
    if (fromSquarePieceType == PieceType.light && !canWhiteKingCastle) {
      return;
    }
    // todo: check castling availability on the start of the game by checking the existing pieces on the squares like the a1 and h8 for example
    if (fromSquarePiece == Pieces.king) {
      if (fromSquarePieceType == PieceType.light) {
        SharedState.instance.didLightKingMove = true;
      } else {
        SharedState.instance.didDarkKingMove = true;
      }
    } else if (fromSquarePiece == Pieces.rook) {
      if (fromSquarePieceType == PieceType.light) {
        if (from == ChessSquare.a1.index) {
          SharedState.instance.didLightQueenSideRookMove = true;
        } else if (from == ChessSquare.h1.index) {
          SharedState.instance.didLightKingSideRookMove = true;
        }
      } else {
        if (from == ChessSquare.a8.index) {
          SharedState.instance.didDarkQueenSideRookMove = true;
        } else if (from == ChessSquare.h8.index) {
          sharedState.didDarkKingSideRookMove = true;
        }
      }
    }
  }

  static void handleMove({
    required int from,
    required int to,
  }) {
    // moving the rook in case a king castled
    castlingController.moveRookOnCastle(
      from: from,
      to: to,
    );

    castlingController.changeCastlingAvailability(from: from);
  }

  void moveRookOnCastle({required int from, required int to}) {
    if (from.piece() == Pieces.king) {
      if (from.type() == PieceType.dark &&
          from == ChessSquare.e8.index &&
          (to == ChessSquare.g8.index || to == ChessSquare.c8.index)) {
        // moving the rook and updating the board
        if (to == ChessSquare.g8.index) {
          ChessBoardModel.move(
              from: ChessSquare.h8.index, to: ChessSquare.f8.index);
        } else {
          ChessBoardModel.move(
              from: ChessSquare.a8.index, to: ChessSquare.d8.index);
        }
      } else if (from.type() == PieceType.light &&
          from == ChessSquare.e1.index &&
          (to == ChessSquare.c1.index || to == ChessSquare.g1.index)) {
        if (to == ChessSquare.g1.index) {
          ChessBoardModel.move(
              from: ChessSquare.h1.index, to: ChessSquare.f1.index);
        } else {
          ChessBoardModel.move(
              from: ChessSquare.a1.index, to: ChessSquare.d1.index);
        }
      }
    }
  }

  static List<int> preventCastlingIfPieceStandsBetweenRookAndKing(
      {required int from, required List<int> legalAndIllegalMoves}) {
    if (from.piece() == Pieces.king) {
      if (from.type() == PieceType.light) {
        if (!SharedState.instance.didLightKingMove) {
          if ((ChessSquare.f1.index).piece() != null ||
              (ChessSquare.g1.index).piece() != null) {
            legalAndIllegalMoves.removeWhere(
              (square) => (square.file() == Files.g && square.rank() == 1),
            );
          }
          if ((ChessSquare.b1.index).piece() != null ||
              (ChessSquare.c1.index).piece() != null ||
              (ChessSquare.d1.index).piece() != null) {
            legalAndIllegalMoves.removeWhere(
              (square) => (square.file() == Files.c && square.rank() == 1),
            );
          }
        }
      } else {
        if (!SharedState.instance.didDarkKingMove) {
          if ((ChessSquare.f8.index).piece() != null ||
              (ChessSquare.g8.index).piece() != null) {
            legalAndIllegalMoves.removeWhere(
              (square) => (square.file() == Files.g && square.rank() == 8),
            );
          }
          if ((ChessSquare.b8.index).piece() != null ||
              (ChessSquare.c8.index).piece() != null ||
              (ChessSquare.d8.index).piece() != null) {
            legalAndIllegalMoves.removeWhere(
              (square) => (square.file() == Files.c && square.rank() == 8),
            );
          }
        }
      }
    }
    return legalAndIllegalMoves;
  }
}
