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
    String castlingRights = SharedState.instance.castlingRights;
    bool didLightKingSideRookMove = !castlingRights.contains('K');
    bool didLightQueenSideRookMove = !castlingRights.contains('Q');
    bool didDarkKingSideRookMove = !castlingRights.contains('k');
    bool didDarkQueenSideRookMove = !castlingRights.contains('q');
    bool didLightKingMove = !castlingRights.contains(RegExp('[A-Z]'));
    bool didDarkKingMove = !castlingRights.contains(RegExp('[a-z]'));

    if (pieceType == PieceType.light) {
      if (didLightKingMove) {
        castlingAvailability = [];
      } else if (didLightKingSideRookMove) {
        castlingAvailability =
            didLightQueenSideRookMove ? [] : [ChessSquare.c1.index];
      } else {
        castlingAvailability = didLightQueenSideRookMove
            ? [ChessSquare.g6.index]
            : [ChessSquare.c1.index, ChessSquare.g1.index];
      }
    } else {
      if (didDarkKingMove) {
        castlingAvailability = [];
      } else if (didDarkKingSideRookMove) {
        castlingAvailability =
            didDarkQueenSideRookMove ? [] : [ChessSquare.c8.index];
      } else {
        castlingAvailability = didDarkQueenSideRookMove
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
    bool canWhiteKingCastle =
        SharedState.instance.castlingRights.contains(RegExp('[A-Z]'));
    bool canBlackKingCastle =
        SharedState.instance.castlingRights.contains(RegExp('[a-z]'));

    if (fromSquarePieceType == PieceType.dark && !canBlackKingCastle) {
      return;
    }
    if (fromSquarePieceType == PieceType.light && !canWhiteKingCastle) {
      return;
    }
    // todo: check castling availability on the start of the game by checking the existing pieces on the squares like the a1 and h8 for example
    if (fromSquarePiece == Pieces.king) {
      if (fromSquarePieceType == PieceType.light) {
        SharedState.instance.updateCastlingRights(lightKingMoved: true);
      } else {
        SharedState.instance.updateCastlingRights(darkKingMoved: true);
      }
    } else if (fromSquarePiece == Pieces.rook) {
      if (fromSquarePieceType == PieceType.light) {
        if (from == ChessSquare.a1.index) {
          SharedState.instance
              .updateCastlingRights(lightQueenSideRookMoved: true);
        } else if (from == ChessSquare.h1.index) {
          SharedState.instance
              .updateCastlingRights(lightKingSideRookMoved: true);
        }
      } else {
        if (from == ChessSquare.a8.index) {
          SharedState.instance
              .updateCastlingRights(darkQueenSideRookMoved: true);
        } else if (from == ChessSquare.h8.index) {
          SharedState.instance
              .updateCastlingRights(darkKingSideRookMoved: true);
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
      {required int from,
      required List<int> legalAndIllegalMoves,
      bool fromHandleSquareTapped = false}) {
    if (!fromHandleSquareTapped) {
      // todo: find a better fix than this for bug #5
      return legalAndIllegalMoves;
    }
    bool didLightKingMove =
        !SharedState.instance.castlingRights.contains(RegExp('[A-Z]'));
    bool didDarkKingMove =
        !SharedState.instance.castlingRights.contains(RegExp('[a-z]'));
    if (from.piece() == Pieces.king) {
      if (from.type() == PieceType.light) {
        if (!didLightKingMove) {
          if ((ChessSquare.f1.index).piece() != null ||
              (ChessSquare.g1.index).piece() != null) {
            legalAndIllegalMoves.removeWhere(
              (move) => (move == ChessSquare.g1.index),
            );
          }
          if ((ChessSquare.b1.index).piece() != null ||
              (ChessSquare.c1.index).piece() != null ||
              (ChessSquare.d1.index).piece() != null) {
            legalAndIllegalMoves.removeWhere(
              (move) => (move == ChessSquare.c1.index),
            );
          }
        }
      } else {
        if (!didDarkKingMove) {
          if ((ChessSquare.f8.index).piece() != null ||
              (ChessSquare.g8.index).piece() != null) {
            legalAndIllegalMoves.removeWhere(
              (move) => (move == ChessSquare.g8.index),
            );
          }
          if ((ChessSquare.b8.index).piece() != null ||
              (ChessSquare.c8.index).piece() != null ||
              (ChessSquare.d8.index).piece() != null) {
            legalAndIllegalMoves.removeWhere(
              (move) => (move == ChessSquare.c8.index),
            );
          }
        }
      }
    }
    return legalAndIllegalMoves;
  }
}
