import 'package:chess/controllers/enums.dart';
import 'package:chess/model/square.dart';

List<Square> initialChessBoard = [
  // -------------------------------First Rank------------------
  Square(
      file: Files.a, rank: 1, piece: Pieces.rook, pieceType: PieceType.light),
  Square(
      file: Files.b, rank: 1, piece: Pieces.knight, pieceType: PieceType.light),
  Square(
      file: Files.c, rank: 1, piece: Pieces.bishop, pieceType: PieceType.light),
  Square(
      file: Files.d, rank: 1, piece: Pieces.queen, pieceType: PieceType.light),
  Square(
      file: Files.e, rank: 1, piece: Pieces.king, pieceType: PieceType.light),
  Square(
      file: Files.f, rank: 1, piece: Pieces.bishop, pieceType: PieceType.light),
  Square(
      file: Files.g, rank: 1, piece: Pieces.knight, pieceType: PieceType.light),
  Square(
      file: Files.h, rank: 1, piece: Pieces.rook, pieceType: PieceType.light),
  // -------------------------------Second Rank------------------
  Square(
      file: Files.a, rank: 2, piece: Pieces.pawn, pieceType: PieceType.light),
  Square(
      file: Files.b, rank: 2, piece: Pieces.pawn, pieceType: PieceType.light),
  Square(
      file: Files.c, rank: 2, piece: Pieces.pawn, pieceType: PieceType.light),
  Square(
      file: Files.d, rank: 2, piece: Pieces.pawn, pieceType: PieceType.light),
  Square(
      file: Files.e, rank: 2, piece: Pieces.pawn, pieceType: PieceType.light),
  Square(
      file: Files.f, rank: 2, piece: Pieces.pawn, pieceType: PieceType.light),
  Square(
      file: Files.g, rank: 2, piece: Pieces.pawn, pieceType: PieceType.light),
  Square(
      file: Files.h, rank: 2, piece: Pieces.pawn, pieceType: PieceType.light),
  // -------------------------------Third Rank------------------
  Square(file: Files.a, rank: 3, piece: null, pieceType: null),
  Square(file: Files.b, rank: 3, piece: null, pieceType: null),
  Square(file: Files.c, rank: 3, piece: null, pieceType: null),
  Square(file: Files.d, rank: 3, piece: null, pieceType: null),
  Square(file: Files.e, rank: 3, piece: null, pieceType: null),
  Square(file: Files.f, rank: 3, piece: null, pieceType: null),
  Square(file: Files.g, rank: 3, piece: null, pieceType: null),
  Square(file: Files.h, rank: 3, piece: null, pieceType: null),
  // -------------------------------Fourth Rank------------------
  Square(file: Files.a, rank: 4, piece: null, pieceType: null),
  Square(file: Files.b, rank: 4, piece: null, pieceType: null),
  Square(file: Files.c, rank: 4, piece: null, pieceType: null),
  Square(file: Files.d, rank: 4, piece: null, pieceType: null),
  Square(file: Files.e, rank: 4, piece: null, pieceType: null),
  Square(file: Files.f, rank: 4, piece: null, pieceType: null),
  Square(file: Files.g, rank: 4, piece: null, pieceType: null),
  Square(file: Files.h, rank: 4, piece: null, pieceType: null),
  // -------------------------------Fifth Rank------------------
  Square(file: Files.a, rank: 5, piece: null, pieceType: null),
  Square(file: Files.b, rank: 5, piece: null, pieceType: null),
  Square(file: Files.c, rank: 5, piece: null, pieceType: null),
  Square(file: Files.d, rank: 5, piece: null, pieceType: null),
  Square(file: Files.e, rank: 5, piece: null, pieceType: null),
  Square(file: Files.f, rank: 5, piece: null, pieceType: null),
  Square(file: Files.g, rank: 5, piece: null, pieceType: null),
  Square(file: Files.h, rank: 5, piece: null, pieceType: null),
  // -------------------------------Sixth Rank------------------
  Square(file: Files.a, rank: 6, piece: null, pieceType: null),
  Square(file: Files.b, rank: 6, piece: null, pieceType: null),
  Square(file: Files.c, rank: 6, piece: null, pieceType: null),
  Square(file: Files.d, rank: 6, piece: null, pieceType: null),
  Square(file: Files.e, rank: 6, piece: null, pieceType: null),
  Square(file: Files.f, rank: 6, piece: null, pieceType: null),
  Square(file: Files.g, rank: 6, piece: null, pieceType: null),
  Square(file: Files.h, rank: 6, piece: null, pieceType: null),
  // -------------------------------Seventh Rank------------------
  Square(file: Files.a, rank: 7, piece: Pieces.pawn, pieceType: PieceType.dark),
  Square(file: Files.b, rank: 7, piece: Pieces.pawn, pieceType: PieceType.dark),
  Square(file: Files.c, rank: 7, piece: Pieces.pawn, pieceType: PieceType.dark),
  Square(file: Files.d, rank: 7, piece: Pieces.pawn, pieceType: PieceType.dark),
  Square(file: Files.e, rank: 7, piece: Pieces.pawn, pieceType: PieceType.dark),
  Square(file: Files.f, rank: 7, piece: Pieces.pawn, pieceType: PieceType.dark),
  Square(file: Files.g, rank: 7, piece: Pieces.pawn, pieceType: PieceType.dark),
  Square(file: Files.h, rank: 7, piece: Pieces.pawn, pieceType: PieceType.dark),
  // -------------------------------Eigth Rank------------------
  Square(file: Files.a, rank: 8, piece: Pieces.rook, pieceType: PieceType.dark),
  Square(
      file: Files.b, rank: 8, piece: Pieces.knight, pieceType: PieceType.dark),
  Square(
      file: Files.c, rank: 8, piece: Pieces.bishop, pieceType: PieceType.dark),
  Square(
      file: Files.d, rank: 8, piece: Pieces.queen, pieceType: PieceType.dark),
  Square(file: Files.e, rank: 8, piece: Pieces.king, pieceType: PieceType.dark),
  Square(
      file: Files.f, rank: 8, piece: Pieces.bishop, pieceType: PieceType.dark),
  Square(
      file: Files.g, rank: 8, piece: Pieces.knight, pieceType: PieceType.dark),
  Square(file: Files.h, rank: 8, piece: Pieces.rook, pieceType: PieceType.dark),
];
