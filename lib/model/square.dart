import 'package:chess/controllers/enums.dart';

class Square {
  Pieces? piece;
  PieceType? pieceType;

  Square({
    required this.piece,
    required this.pieceType,
  });

  Square copy() {
    return Square(
      piece: piece,
      pieceType: pieceType,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Square && piece == other.piece;
  }

  @override
  int get hashCode => piece.hashCode ^ pieceType.hashCode;
}
