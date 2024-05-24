import 'package:chess/controllers/enums.dart';
import 'package:chess/controllers/helper_methods.dart';
import 'package:chess/model/chess_board_model.dart';
import 'package:chess/model/global_state.dart';
import 'package:chess/model/square.dart';
import 'package:chess/utils/index_to_square_map.dart';

class CastlingController {
  // Private constructor
  CastlingController._private();

  // Private static instance
  static final CastlingController _instance = CastlingController._private();

  // Public static method to access the instance
  static CastlingController get instance => _instance;
  //-------------------------State------------------------------------------------
  static bool didLightKingSideRookMove = false;
  static bool didLightQueenSideRookMove = false;
  static bool didDarkKingSideRookMove = false;
  static bool didDarkQueenSideRookMove = false;

  static bool didLightKingMove = false;
  static bool didDarkKingMove = false;

  static void resetState() {
    didLightKingMove = false;
    didDarkKingMove = false;
    didLightKingSideRookMove = false;
    didLightQueenSideRookMove = false;
    didDarkKingSideRookMove = false;
    didDarkQueenSideRookMove = false;
  }

  //----------------------------------------------------------------------------
  // todo: handle cases where there aren't rooks on the start of the game
  List<Square> getCastlingAvailability({required PieceType pieceType}) {
    List<Square> castlingAvailability;
    if (pieceType == PieceType.light) {
      if (didLightKingMove) {
        castlingAvailability = [];
      } else if (didLightKingSideRookMove) {
        castlingAvailability = didLightQueenSideRookMove
            ? []
            : [(ChessSquare.c1.index).toSquare()];
      } else {
        castlingAvailability = didLightQueenSideRookMove
            ? [(ChessSquare.g6.index).toSquare()]
            : [
                (ChessSquare.c1.index).toSquare(),
                (ChessSquare.g1.index).toSquare()
              ];
      }
    } else {
      if (didDarkKingMove) {
        castlingAvailability = [];
      } else if (didDarkKingSideRookMove) {
        castlingAvailability =
            didDarkQueenSideRookMove ? [] : [(ChessSquare.c8.index).toSquare()];
      } else {
        castlingAvailability = didDarkQueenSideRookMove
            ? [(ChessSquare.g8.index).toSquare()]
            : [
                (ChessSquare.c8.index).toSquare(),
                (ChessSquare.g8.index).toSquare()
              ];
      }
    }
    return castlingAvailability;
  }

  void changeCastlingAvailability({required int from}) {
    PieceType fromSquarePieceType = from.toPieceType()!;
    Pieces fromSquarePiece = from.toPiece()!;
    // checking if castling is possible in the first place before checking all the other conditions
    bool canWhiteKingCastle = !didLightKingMove &&
        (!didLightKingSideRookMove || !didLightQueenSideRookMove);
    bool canBlackKingCastle = !didDarkKingMove &&
        (!didDarkKingSideRookMove || !didDarkQueenSideRookMove);

    if (fromSquarePieceType == PieceType.dark && !canBlackKingCastle) {
      return;
    }
    if (fromSquarePieceType == PieceType.light && !canWhiteKingCastle) {
      return;
    }
    // todo: check castling availability on the start of the game by checking the existing pieces on the squares like the a1 and h8 for example
    if (fromSquarePiece == Pieces.king) {
      if (fromSquarePieceType == PieceType.light) {
        didLightKingMove = true;
      } else {
        didDarkKingMove = true;
      }
    } else if (fromSquarePiece == Pieces.rook) {
      if (fromSquarePieceType == PieceType.light) {
        if (from == ChessSquare.a1.index) {
          didLightQueenSideRookMove = true;
        } else if (from == ChessSquare.h1.index) {
          didLightKingSideRookMove = true;
        }
      } else {
        if (from == ChessSquare.a8.index) {
          didDarkQueenSideRookMove = true;
        } else if (from == ChessSquare.h8.index) {
          didDarkKingSideRookMove = true;
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
    if (from.toPiece() == Pieces.king) {
      if (from.toPieceType() == PieceType.dark &&
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
      } else if (from.toPieceType() == PieceType.light &&
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

  static List<Square> preventCastlingIfPieceStandsBetweenRookAndKing(
      {required int from, required List<Square> legalAndIllegalMoves}) {
    if (from.toPiece() == Pieces.king) {
      if (from.toPieceType() == PieceType.light) {
        if (!CastlingController.didLightKingMove) {
          if ((ChessSquare.f1.index).toPiece() != null ||
              (ChessSquare.g1.index).toPiece() != null) {
            legalAndIllegalMoves.removeWhere(
              (square) => (square.file == Files.g && square.rank == 1),
            );
          }
          if ((ChessSquare.b1.index).toPiece() != null ||
              (ChessSquare.c1.index).toPiece() != null ||
              (ChessSquare.d1.index).toPiece() != null) {
            legalAndIllegalMoves.removeWhere(
              (square) => (square.file == Files.c && square.rank == 1),
            );
          }
        }
      } else {
        if (!CastlingController.didDarkKingMove) {
          if ((ChessSquare.f8.index).toPiece() != null ||
              (ChessSquare.g8.index).toPiece() != null) {
            legalAndIllegalMoves.removeWhere(
              (square) => (square.file == Files.g && square.rank == 8),
            );
          }
          if ((ChessSquare.b8.index).toPiece() != null ||
              (ChessSquare.c8.index).toPiece() != null ||
              (ChessSquare.d8.index).toPiece() != null) {
            legalAndIllegalMoves.removeWhere(
              (square) => (square.file == Files.c && square.rank == 8),
            );
          }
        }
      }
    }
    return legalAndIllegalMoves;
  }
}
