import 'package:chess/controllers/enums.dart';
import 'package:chess/model/square.dart';
import 'package:chess/utils/extensions.dart';

class ChessBoardModel {
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
    ChessSquare.a3: Square(piece: null, pieceType: null),
    ChessSquare.b3: Square(piece: null, pieceType: null),
    ChessSquare.c3: Square(piece: null, pieceType: null),
    ChessSquare.d3: Square(piece: null, pieceType: null),
    ChessSquare.e3: Square(piece: null, pieceType: null),
    ChessSquare.f3: Square(piece: null, pieceType: null),
    ChessSquare.g3: Square(piece: null, pieceType: null),
    ChessSquare.h3: Square(piece: null, pieceType: null),
    // -------------------------------Fourth Rank------------------
    ChessSquare.a4: Square(piece: null, pieceType: null),
    ChessSquare.b4: Square(piece: null, pieceType: null),
    ChessSquare.c4: Square(piece: null, pieceType: null),
    ChessSquare.d4: Square(piece: null, pieceType: null),
    ChessSquare.e4: Square(piece: null, pieceType: null),
    ChessSquare.f4: Square(piece: null, pieceType: null),
    ChessSquare.g4: Square(piece: null, pieceType: null),
    ChessSquare.h4: Square(piece: null, pieceType: null),
    // -------------------------------Fifth Rank------------------
    ChessSquare.a5: Square(piece: null, pieceType: null),
    ChessSquare.b5: Square(piece: null, pieceType: null),
    ChessSquare.c5: Square(piece: null, pieceType: null),
    ChessSquare.d5: Square(piece: null, pieceType: null),
    ChessSquare.e5: Square(piece: null, pieceType: null),
    ChessSquare.f5: Square(piece: null, pieceType: null),
    ChessSquare.g5: Square(piece: null, pieceType: null),
    ChessSquare.h5: Square(piece: null, pieceType: null),
    // -------------------------------Sixth Rank------------------
    ChessSquare.a6: Square(piece: null, pieceType: null),
    ChessSquare.b6: Square(piece: null, pieceType: null),
    ChessSquare.c6: Square(piece: null, pieceType: null),
    ChessSquare.d6: Square(piece: null, pieceType: null),
    ChessSquare.e6: Square(piece: null, pieceType: null),
    ChessSquare.f6: Square(piece: null, pieceType: null),
    ChessSquare.g6: Square(piece: null, pieceType: null),
    ChessSquare.h6: Square(piece: null, pieceType: null),
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
    emptySquareAtIndex(from);
    updateSquareAtIndex(to, pawnPromotedTo ?? piece, type);
  }
}
