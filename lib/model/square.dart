import 'package:chess/controllers/enums.dart';

class Square {
  final Files file;
  final int rank;
  Pieces? piece;
  PieceType? pieceType;

  Square({
    required this.file,
    required this.rank,
    required this.piece,
    required this.pieceType,
  });

  Square copy() {
    return Square(
      file: file,
      rank: rank,
      piece: piece,
      pieceType: pieceType,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Square &&
        file == other.file &&
        rank == other.rank &&
        piece == other.piece;
  }

  @override
  int get hashCode =>
      file.hashCode ^ rank.hashCode ^ piece.hashCode ^ pieceType.hashCode;
}
