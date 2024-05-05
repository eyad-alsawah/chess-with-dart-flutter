import 'package:chess/controllers/enums.dart';

class Square {
  Files file;
  int rank;
  Pieces? piece;
  PieceType? pieceType;

  Square({
    required this.file,
    required this.rank,
    required this.piece,
    required this.pieceType,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Square &&
          file == other.file &&
          rank == other.rank &&
          piece == other.piece &&
          pieceType == other.pieceType;
}
