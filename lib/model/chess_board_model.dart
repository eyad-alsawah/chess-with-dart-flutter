import 'package:chess/controllers/enums.dart';
import 'package:chess/controllers/shared_state.dart';
import 'package:chess/model/square.dart';
import 'package:chess/utils/colored_printer.dart';
import 'package:chess/utils/extensions.dart';

class ChessBoardModel {
  static Square emptySquare = Square(piece: null, pieceType: null);
  static Map<ChessSquare, Square> chessBoard = {
    // -------------------------------First Rank------------------
    ChessSquare.a1: Square(piece: Pieces.rook, pieceType: PieceType.light),
    ChessSquare.b1: Square(piece: Pieces.knight, pieceType: PieceType.light),
    ChessSquare.c1: Square(piece: Pieces.bishop, pieceType: PieceType.light),
    ChessSquare.d1: Square(piece: Pieces.queen, pieceType: PieceType.light),
    ChessSquare.e1: Square(piece: Pieces.king, pieceType: PieceType.light),
    ChessSquare.f1: Square(piece: Pieces.bishop, pieceType: PieceType.light),
    ChessSquare.g1: Square(piece: Pieces.knight, pieceType: PieceType.light),
    ChessSquare.h1: Square(piece: Pieces.rook, pieceType: PieceType.light),
    // -------------------------------Second Rank------------------
    ChessSquare.a2: Square(piece: Pieces.pawn, pieceType: PieceType.light),
    ChessSquare.b2: Square(piece: Pieces.pawn, pieceType: PieceType.light),
    ChessSquare.c2: Square(piece: Pieces.pawn, pieceType: PieceType.light),
    ChessSquare.d2: Square(piece: Pieces.pawn, pieceType: PieceType.light),
    ChessSquare.e2: Square(piece: Pieces.pawn, pieceType: PieceType.light),
    ChessSquare.f2: Square(piece: Pieces.pawn, pieceType: PieceType.light),
    ChessSquare.g2: Square(piece: Pieces.pawn, pieceType: PieceType.light),
    ChessSquare.h2: Square(piece: Pieces.pawn, pieceType: PieceType.light),
    // -------------------------------Third Rank------------------
    ChessSquare.a3: emptySquare,
    ChessSquare.b3: emptySquare,
    ChessSquare.c3: emptySquare,
    ChessSquare.d3: emptySquare,
    ChessSquare.e3: emptySquare,
    ChessSquare.f3: emptySquare,
    ChessSquare.g3: emptySquare,
    ChessSquare.h3: emptySquare,
    // -------------------------------Fourth Rank------------------
    ChessSquare.a4: emptySquare,
    ChessSquare.b4: emptySquare,
    ChessSquare.c4: emptySquare,
    ChessSquare.d4: emptySquare,
    ChessSquare.e4: emptySquare,
    ChessSquare.f4: emptySquare,
    ChessSquare.g4: emptySquare,
    ChessSquare.h4: emptySquare,
    // -------------------------------Fifth Rank------------------
    ChessSquare.a5: emptySquare,
    ChessSquare.b5: emptySquare,
    ChessSquare.c5: emptySquare,
    ChessSquare.d5: emptySquare,
    ChessSquare.e5: emptySquare,
    ChessSquare.f5: emptySquare,
    ChessSquare.g5: emptySquare,
    ChessSquare.h5: emptySquare,
    // -------------------------------Sixth Rank------------------
    ChessSquare.a6: emptySquare,
    ChessSquare.b6: emptySquare,
    ChessSquare.c6: emptySquare,
    ChessSquare.d6: emptySquare,
    ChessSquare.e6: emptySquare,
    ChessSquare.f6: emptySquare,
    ChessSquare.g6: emptySquare,
    ChessSquare.h6: emptySquare,
    // -------------------------------Seventh Rank------------------
    ChessSquare.a7: Square(piece: Pieces.pawn, pieceType: PieceType.dark),
    ChessSquare.b7: Square(piece: Pieces.pawn, pieceType: PieceType.dark),
    ChessSquare.c7: Square(piece: Pieces.pawn, pieceType: PieceType.dark),
    ChessSquare.d7: Square(piece: Pieces.pawn, pieceType: PieceType.dark),
    ChessSquare.e7: Square(piece: Pieces.pawn, pieceType: PieceType.dark),
    ChessSquare.f7: Square(piece: Pieces.pawn, pieceType: PieceType.dark),
    ChessSquare.g7: Square(piece: Pieces.pawn, pieceType: PieceType.dark),
    ChessSquare.h7: Square(piece: Pieces.pawn, pieceType: PieceType.dark),
    // -------------------------------Eigth Rank------------------
    ChessSquare.a8: Square(piece: Pieces.rook, pieceType: PieceType.dark),
    ChessSquare.b8: Square(piece: Pieces.knight, pieceType: PieceType.dark),
    ChessSquare.c8: Square(piece: Pieces.bishop, pieceType: PieceType.dark),
    ChessSquare.d8: Square(piece: Pieces.queen, pieceType: PieceType.dark),
    ChessSquare.e8: Square(piece: Pieces.king, pieceType: PieceType.dark),
    ChessSquare.f8: Square(piece: Pieces.bishop, pieceType: PieceType.dark),
    ChessSquare.g8: Square(piece: Pieces.knight, pieceType: PieceType.dark),
    ChessSquare.h8: Square(piece: Pieces.rook, pieceType: PieceType.dark),
  };

  static List<Square> currentChessBoard() {
    List<Square> currentBoard = [];
    chessBoard.forEach((key, value) {
      currentBoard.add(value.copy());
    });

    return currentBoard;
  }

  static Future<void> clearBoard() async {
    chessBoard.clear();
  }

  static Future<void> addAll(List<Square> squares) async {
    squares.asMap().forEach((index, value) {
      chessBoard[ChessSquare.values[index]] = value;
    });
  }

  static int getIndexOfSquare(Square square) {
    return chessBoard.entries
        .firstWhere((element) => element.value == square)
        .key
        .index;
  }

  static int getIndexOfSquareAtFileAndRank(
      {required Files file, required int rank}) {
    return chessBoard.entries
        .firstWhere((element) =>
            element.key.rank() == rank && element.key.file() == file)
        .key
        .index;
  }

  static int getIndexWherePieceAndPieceTypeMatch(Pieces? piece, PieceType? type,
      {required bool matchPiece, required bool matchType}) {
    return chessBoard.entries
        .firstWhere((entry) =>
            (matchPiece
                ? entry.value.piece == piece
                : entry.value.piece != piece) &&
            (matchType
                ? entry.value.pieceType == type
                : entry.value.pieceType != type))
        .key
        .index;
  }

  //----------------------
  static Future<void> updateSquareAtIndex(
    int index,
    Pieces? piece,
    PieceType? type,
  ) async {
    chessBoard.update(ChessSquare.values[index],
        (value) => Square(piece: piece, pieceType: type));
  }

  static Future<void> emptySquareAtIndex(int index) async {
    chessBoard.update(ChessSquare.values[index],
        (value) => Square(piece: null, pieceType: null));
  }

  //-----------------------------
  static Future<void> move(
      {required int from, required int to, Pieces? pawnPromotedTo}) async {
    PieceType? type = from.type();
    Pieces? piece = from.piece();
    // increase halfMoveClock if no pawn was moved, or no capture happened
    if (piece == Pieces.pawn || to.type() != null) {
      SharedState.instance.halfMoveClock = 0;
      ColoredPrinter.printColored("resetting halfmove clock");
    } else {
      SharedState.instance.halfMoveClock++;
      ColoredPrinter.printColored("increasing halfmove clock");
    }

    emptySquareAtIndex(from);
    updateSquareAtIndex(to, pawnPromotedTo ?? piece, type);
  }

  static String toFen(
      {required String activeColor,
      required String enPassantTargetSquare,
      required String castlingRights,
      required int halfMoveClock,
      required int fullMoveNumber}) {
    String fen = '';
    List<String> piecesPlacementOnRanks = [];
    //----------------------------------------------------------------------
    int emptySquares = 0;

    for (int i = 0; i <= 63; i++) {
      Square? square = ChessSquare.values[i].index.square();
      Pieces? piece = square.piece;
      PieceType? type = square.pieceType;
      bool isLight = type == PieceType.light;

      if (piece != null && emptySquares != 0) {
        fen += emptySquares.toString();
        emptySquares = 0;
      }

      switch (piece) {
        case Pieces.rook:
          fen += isLight ? 'R' : 'r';
          break;
        case Pieces.knight:
          fen += isLight ? 'N' : 'n';
          break;
        case Pieces.bishop:
          fen += isLight ? 'B' : 'b';
          break;
        case Pieces.queen:
          fen += isLight ? 'Q' : 'q';
          break;
        case Pieces.king:
          fen += isLight ? 'K' : 'k';
          break;
        case Pieces.pawn:
          fen += isLight ? 'P' : 'p';
          break;
        default:
          emptySquares++;
          break;
      }

      if ([
        ChessSquare.h1,
        ChessSquare.h2,
        ChessSquare.h3,
        ChessSquare.h4,
        ChessSquare.h5,
        ChessSquare.h6,
        ChessSquare.h7,
        ChessSquare.h8,
      ].any((e) => e.index == i)) {
        if (emptySquares != 0) {
          fen += emptySquares.toString();
        }
        emptySquares = 0;
        piecesPlacementOnRanks.add(fen);
        fen = '';
      }
    }

    return '${piecesPlacementOnRanks.reversed.join('/')} $activeColor $castlingRights $enPassantTargetSquare $halfMoveClock $fullMoveNumber';
  }
}
