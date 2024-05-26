import 'package:chess/controllers/enums.dart';
import 'package:chess/model/chess_board_model.dart';
import 'package:chess/model/square.dart';

extension ListDeepCopy<T> on List<T> {
  List<T> deepCopy() {
    return map((element) {
      if (element is List) {
        return element.deepCopy() as T; // Recursively deep copy nested lists
      } else if (element is Map) {
        return element.map((key, value) => MapEntry(key, value.deepCopy()))
            as T; // Deep copy maps
      } else if (element is Set) {
        return element.map((value) => value.deepCopy()).toSet()
            as T; // Deep copy elements in sets
      } else {
        return element; // Return other types as is
      }
    }).toList();
  }
}

extension PlayingTurnToPieceType on PlayingTurn {
  PieceType type() {
    return this == PlayingTurn.light ? PieceType.light : PieceType.dark;
  }
}

extension PlayingTurnToActiveColor on PlayingTurn {
  String activeColor() {
    return this == PlayingTurn.light ? 'w' : 'b';
  }
}

extension ToSquare on int {
  Square square() {
    return ChessBoardModel.chessBoard[ChessSquare.values[this]]!.copy();
  }
}

extension ChessSquareToRank on ChessSquare {
  int rank() {
    return int.parse(name[1]);
  }
}

extension ChessSquareToFile on ChessSquare {
  Files file() {
    String fileStr = name[0];
    late Files fileEnum;
    switch (fileStr) {
      case 'a':
        fileEnum = Files.a;
        break;
      case 'b':
        fileEnum = Files.b;
        break;
      case 'c':
        fileEnum = Files.c;
        break;
      case 'd':
        fileEnum = Files.d;
        break;
      case 'e':
        fileEnum = Files.e;
        break;
      case 'f':
        fileEnum = Files.f;
        break;
      case 'g':
        fileEnum = Files.g;
        break;
      case 'h':
        fileEnum = Files.h;
        break;
    }
    return fileEnum;
  }
}

extension ToPiece on int {
  Pieces? piece() {
    return square().piece;
  }
}

extension ToPieceType on int {
  PieceType? type() {
    return square().pieceType;
  }
}

extension ToOppositeType on PieceType {
  PieceType? oppositeType() {
    return this == PieceType.light ? PieceType.dark : PieceType.light;
  }
}

extension ToFile on int {
  Files file() {
    return Files.values[this % 8];
  }
}

extension ToPlayingTurn on PieceType {
  PlayingTurn playingTurn() {
    return this == PieceType.light ? PlayingTurn.light : PlayingTurn.dark;
  }
}

extension ToRank on int {
  int rank() {
    return (this ~/ 8) + 1;
  }
}

extension ToCoordinates on int {
  String toCoordinates() {
    return ChessSquare.values[this].name;
  }
}

extension FromCoordinates on String {
  int fromCoordinates() {
    return ChessSquare.values.firstWhere((e) => e.name == this).index;
  }
}
