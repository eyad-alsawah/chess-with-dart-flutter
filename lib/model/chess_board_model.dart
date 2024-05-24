import 'package:chess/controllers/enums.dart';
import 'package:chess/controllers/helper_methods.dart';
import 'package:chess/model/square.dart';
import 'package:chess/utils/colored_printer.dart';
import 'package:chess/utils/index_to_square_map.dart';

class ChessBoardModel {
  static Map<int, Square> chessBoard = {
    // -------------------------------First Rank------------------
    ChessSquare.a1.index: Square(
        file: Files.a, rank: 1, piece: Pieces.rook, pieceType: PieceType.light),
    ChessSquare.b1.index: Square(
        file: Files.b,
        rank: 1,
        piece: Pieces.knight,
        pieceType: PieceType.light),
    ChessSquare.c1.index: Square(
        file: Files.c,
        rank: 1,
        piece: Pieces.bishop,
        pieceType: PieceType.light),
    ChessSquare.d1.index: Square(
        file: Files.d,
        rank: 1,
        piece: Pieces.queen,
        pieceType: PieceType.light),
    ChessSquare.e1.index: Square(
        file: Files.e, rank: 1, piece: Pieces.king, pieceType: PieceType.light),
    ChessSquare.f1.index: Square(
        file: Files.f,
        rank: 1,
        piece: Pieces.bishop,
        pieceType: PieceType.light),
    ChessSquare.g1.index: Square(
        file: Files.g,
        rank: 1,
        piece: Pieces.knight,
        pieceType: PieceType.light),
    ChessSquare.h1.index: Square(
        file: Files.h, rank: 1, piece: Pieces.rook, pieceType: PieceType.light),
    // -------------------------------Second Rank------------------
    ChessSquare.a2.index: Square(
        file: Files.a, rank: 2, piece: Pieces.pawn, pieceType: PieceType.light),
    ChessSquare.b2.index: Square(
        file: Files.b, rank: 2, piece: Pieces.pawn, pieceType: PieceType.light),
    ChessSquare.c2.index: Square(
        file: Files.c, rank: 2, piece: Pieces.pawn, pieceType: PieceType.light),
    ChessSquare.d2.index: Square(
        file: Files.d, rank: 2, piece: Pieces.pawn, pieceType: PieceType.light),
    ChessSquare.e2.index: Square(
        file: Files.e, rank: 2, piece: Pieces.pawn, pieceType: PieceType.light),
    ChessSquare.f2.index: Square(
        file: Files.f, rank: 2, piece: Pieces.pawn, pieceType: PieceType.light),
    ChessSquare.g2.index: Square(
        file: Files.g, rank: 2, piece: Pieces.pawn, pieceType: PieceType.light),
    ChessSquare.h2.index: Square(
        file: Files.h, rank: 2, piece: Pieces.pawn, pieceType: PieceType.light),
    // -------------------------------Third Rank------------------
    ChessSquare.a3.index:
        Square(file: Files.a, rank: 3, piece: null, pieceType: null),
    ChessSquare.b3.index:
        Square(file: Files.b, rank: 3, piece: null, pieceType: null),
    ChessSquare.c3.index:
        Square(file: Files.c, rank: 3, piece: null, pieceType: null),
    ChessSquare.d3.index:
        Square(file: Files.d, rank: 3, piece: null, pieceType: null),
    ChessSquare.e3.index:
        Square(file: Files.e, rank: 3, piece: null, pieceType: null),
    ChessSquare.f3.index:
        Square(file: Files.f, rank: 3, piece: null, pieceType: null),
    ChessSquare.g3.index:
        Square(file: Files.g, rank: 3, piece: null, pieceType: null),
    ChessSquare.h3.index:
        Square(file: Files.h, rank: 3, piece: null, pieceType: null),
    // -------------------------------Fourth Rank------------------
    ChessSquare.a4.index:
        Square(file: Files.a, rank: 4, piece: null, pieceType: null),
    ChessSquare.b4.index:
        Square(file: Files.b, rank: 4, piece: null, pieceType: null),
    ChessSquare.c4.index:
        Square(file: Files.c, rank: 4, piece: null, pieceType: null),
    ChessSquare.d4.index:
        Square(file: Files.d, rank: 4, piece: null, pieceType: null),
    ChessSquare.e4.index:
        Square(file: Files.e, rank: 4, piece: null, pieceType: null),
    ChessSquare.f4.index:
        Square(file: Files.f, rank: 4, piece: null, pieceType: null),
    ChessSquare.g4.index:
        Square(file: Files.g, rank: 4, piece: null, pieceType: null),
    ChessSquare.h4.index:
        Square(file: Files.h, rank: 4, piece: null, pieceType: null),
    // -------------------------------Fifth Rank------------------
    ChessSquare.a5.index:
        Square(file: Files.a, rank: 5, piece: null, pieceType: null),
    ChessSquare.b5.index:
        Square(file: Files.b, rank: 5, piece: null, pieceType: null),
    ChessSquare.c5.index:
        Square(file: Files.c, rank: 5, piece: null, pieceType: null),
    ChessSquare.d5.index:
        Square(file: Files.d, rank: 5, piece: null, pieceType: null),
    ChessSquare.e5.index:
        Square(file: Files.e, rank: 5, piece: null, pieceType: null),
    ChessSquare.f5.index:
        Square(file: Files.f, rank: 5, piece: null, pieceType: null),
    ChessSquare.g5.index:
        Square(file: Files.g, rank: 5, piece: null, pieceType: null),
    ChessSquare.h5.index:
        Square(file: Files.h, rank: 5, piece: null, pieceType: null),
    // -------------------------------Sixth Rank------------------
    ChessSquare.a6.index:
        Square(file: Files.a, rank: 6, piece: null, pieceType: null),
    ChessSquare.b6.index:
        Square(file: Files.b, rank: 6, piece: null, pieceType: null),
    ChessSquare.c6.index:
        Square(file: Files.c, rank: 6, piece: null, pieceType: null),
    ChessSquare.d6.index:
        Square(file: Files.d, rank: 6, piece: null, pieceType: null),
    ChessSquare.e6.index:
        Square(file: Files.e, rank: 6, piece: null, pieceType: null),
    ChessSquare.f6.index:
        Square(file: Files.f, rank: 6, piece: null, pieceType: null),
    ChessSquare.g6.index:
        Square(file: Files.g, rank: 6, piece: null, pieceType: null),
    ChessSquare.h6.index:
        Square(file: Files.h, rank: 6, piece: null, pieceType: null),
    // -------------------------------Seventh Rank------------------
    ChessSquare.a7.index: Square(
        file: Files.a, rank: 7, piece: Pieces.pawn, pieceType: PieceType.dark),
    ChessSquare.b7.index: Square(
        file: Files.b, rank: 7, piece: Pieces.pawn, pieceType: PieceType.dark),
    ChessSquare.c7.index: Square(
        file: Files.c, rank: 7, piece: Pieces.pawn, pieceType: PieceType.dark),
    ChessSquare.d7.index: Square(
        file: Files.d, rank: 7, piece: Pieces.pawn, pieceType: PieceType.dark),
    ChessSquare.e7.index: Square(
        file: Files.e, rank: 7, piece: Pieces.pawn, pieceType: PieceType.dark),
    ChessSquare.f7.index: Square(
        file: Files.f, rank: 7, piece: Pieces.pawn, pieceType: PieceType.dark),
    ChessSquare.g7.index: Square(
        file: Files.g, rank: 7, piece: Pieces.pawn, pieceType: PieceType.dark),
    ChessSquare.h7.index: Square(
        file: Files.h, rank: 7, piece: Pieces.pawn, pieceType: PieceType.dark),
    // -------------------------------Eigth Rank------------------
    ChessSquare.a8.index: Square(
        file: Files.a, rank: 8, piece: Pieces.rook, pieceType: PieceType.dark),
    ChessSquare.b8.index: Square(
        file: Files.b,
        rank: 8,
        piece: Pieces.knight,
        pieceType: PieceType.dark),
    ChessSquare.c8.index: Square(
        file: Files.c,
        rank: 8,
        piece: Pieces.bishop,
        pieceType: PieceType.dark),
    ChessSquare.d8.index: Square(
        file: Files.d, rank: 8, piece: Pieces.queen, pieceType: PieceType.dark),
    ChessSquare.e8.index: Square(
        file: Files.e, rank: 8, piece: Pieces.king, pieceType: PieceType.dark),
    ChessSquare.f8.index: Square(
        file: Files.f,
        rank: 8,
        piece: Pieces.bishop,
        pieceType: PieceType.dark),
    ChessSquare.g8.index: Square(
        file: Files.g,
        rank: 8,
        piece: Pieces.knight,
        pieceType: PieceType.dark),
    ChessSquare.h8.index: Square(
        file: Files.h, rank: 8, piece: Pieces.rook, pieceType: PieceType.dark),
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
      chessBoard[index] = value;
    });
  }

  static int getIndexOfSquare(Square square) {
    int index =
        chessBoard.entries.firstWhere((element) => element.value == square).key;
    if (index == -1) {
      ColoredPrinter.printColored(
          "getIndexOfSquare: for ${square.file}${square.rank} caused -1");
    }
    return index;
  }

  static int getIndexOfSquareAtFileAndRank(
      {required Files file, required int rank}) {
    return chessBoard.entries
        .firstWhere((element) =>
            element.value.rank == rank && element.value.file == file)
        .key;
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
        .key;
  }

  //----------------------
  static Future<void> updateSquareAtIndex(
    int index,
    Pieces? piece,
    PieceType? type,
  ) async {
    chessBoard[index]?.piece = piece;
    chessBoard[index]?.pieceType = type;
  }

  static Future<void> emptySquareAtIndex(int index) async {
    chessBoard[index]?.piece = null;
    chessBoard[index]?.pieceType = null;
  }

  //-----------------------------
  static Future<void> move(
      {required int from, required int to, Pieces? pawnPromotedTo}) async {
    PieceType? type = from.toPieceType();
    Pieces? piece = from.toPiece();
    emptySquareAtIndex(from);
    updateSquareAtIndex(to, pawnPromotedTo ?? piece, type);
  }
}
