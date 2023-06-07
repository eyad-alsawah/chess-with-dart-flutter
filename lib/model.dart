import 'dart:math';

import 'game_controller.dart';

List<Map<String, dynamic>> chessBoard = [
  // -----------------------------------rank 1----------------------------
  {
    "file": Files.a,
    "rank": 1,
    "piece": Pieces.rook,
    "type": PieceTypeT.light,
  },
  {
    "file": Files.b,
    "rank": 1,
    "piece": Pieces.knight,
    "type": PieceTypeT.light
  },
  {
    "file": Files.c,
    "rank": 1,
    "piece": Pieces.bishop,
    "type": PieceTypeT.light
  },
  {"file": Files.d, "rank": 1, "piece": Pieces.queen, "type": PieceTypeT.light},
  {"file": Files.e, "rank": 1, "piece": Pieces.king, "type": PieceTypeT.light},
  {
    "file": Files.f,
    "rank": 1,
    "piece": Pieces.bishop,
    "type": PieceTypeT.light
  },
  {
    "file": Files.g,
    "rank": 1,
    "piece": Pieces.knight,
    "type": PieceTypeT.light
  },
  {"file": Files.h, "rank": 1, "piece": Pieces.rook, "type": PieceTypeT.light},
  //--------------------------- rank 2----------------------------------------
  {"file": Files.a, "rank": 2, "piece": Pieces.pawn, "type": PieceTypeT.light},
  {"file": Files.b, "rank": 2, "piece": Pieces.pawn, "type": PieceTypeT.light},
  {"file": Files.c, "rank": 2, "piece": Pieces.pawn, "type": PieceTypeT.light},
  {"file": Files.d, "rank": 2, "piece": Pieces.pawn, "type": PieceTypeT.light},
  {"file": Files.e, "rank": 2, "piece": Pieces.pawn, "type": PieceTypeT.light},
  {"file": Files.f, "rank": 2, "piece": Pieces.pawn, "type": PieceTypeT.light},
  {"file": Files.g, "rank": 2, "piece": Pieces.pawn, "type": PieceTypeT.light},
  {"file": Files.h, "rank": 2, "piece": Pieces.pawn, "type": PieceTypeT.light},
  //------------------------------rank 3---------------------------------------
  {"file": Files.a, "rank": 3, "piece": null, "type": null},
  {"file": Files.b, "rank": 3, "piece": null, "type": null},
  {"file": Files.c, "rank": 3, "piece": null, "type": null},
  {"file": Files.d, "rank": 3, "piece": null, "type": null},
  {"file": Files.e, "rank": 3, "piece": null, "type": null},
  {"file": Files.f, "rank": 3, "piece": null, "type": null},
  {"file": Files.g, "rank": 3, "piece": null, "type": null},
  {"file": Files.h, "rank": 3, "piece": null, "type": null},
  //-----------------------------rank 4------------------------------------
  {"file": Files.a, "rank": 4, "piece": null, "type": null},
  {"file": Files.b, "rank": 4, "piece": null, "type": null},
  {"file": Files.c, "rank": 4, "piece": null, "type": null},
  {"file": Files.d, "rank": 4, "piece": null, "type": null},
  {"file": Files.e, "rank": 4, "piece": null, "type": null},
  {"file": Files.f, "rank": 4, "piece": null, "type": null},
  {"file": Files.g, "rank": 4, "piece": null, "type": null},
  {"file": Files.h, "rank": 4, "piece": null, "type": null},
  //-----------------------------------rank 5----------------------------------
  {"file": Files.a, "rank": 5, "piece": null, "type": null},
  {"file": Files.b, "rank": 5, "piece": null, "type": null},
  {"file": Files.c, "rank": 5, "piece": null, "type": null},
  {"file": Files.d, "rank": 5, "piece": null, "type": null},
  {"file": Files.e, "rank": 5, "piece": null, "type": null},
  {"file": Files.f, "rank": 5, "piece": null, "type": null},
  {"file": Files.g, "rank": 5, "piece": null, "type": null},
  {"file": Files.h, "rank": 5, "piece": null, "type": null},
  //-----------------------------------rank 6----------------------------------
  {"file": Files.a, "rank": 6, "piece": null, "type": null},
  {"file": Files.b, "rank": 6, "piece": null, "type": null},
  {"file": Files.c, "rank": 6, "piece": null, "type": null},
  {"file": Files.d, "rank": 6, "piece": null, "type": null},
  {"file": Files.e, "rank": 6, "piece": null, "type": null},
  {"file": Files.f, "rank": 6, "piece": null, "type": null},
  {"file": Files.g, "rank": 6, "piece": null, "type": null},
  {"file": Files.h, "rank": 6, "piece": null, "type": null},
  //-----------------------------------rank 7----------------------------------
  {"file": Files.a, "rank": 7, "piece": Pieces.pawn, "type": PieceTypeT.dark},
  {"file": Files.b, "rank": 7, "piece": Pieces.pawn, "type": PieceTypeT.dark},
  {"file": Files.c, "rank": 7, "piece": Pieces.pawn, "type": PieceTypeT.dark},
  {"file": Files.d, "rank": 7, "piece": Pieces.pawn, "type": PieceTypeT.dark},
  {"file": Files.e, "rank": 7, "piece": Pieces.pawn, "type": PieceTypeT.dark},
  {"file": Files.f, "rank": 7, "piece": Pieces.pawn, "type": PieceTypeT.dark},
  {"file": Files.g, "rank": 7, "piece": Pieces.pawn, "type": PieceTypeT.dark},
  {"file": Files.h, "rank": 7, "piece": Pieces.pawn, "type": PieceTypeT.dark},
  //------------------------------------rank 8----------------------------------
  {"file": Files.a, "rank": 8, "piece": Pieces.rook, "type": PieceTypeT.dark},
  {"file": Files.b, "rank": 8, "piece": Pieces.knight, "type": PieceTypeT.dark},
  {"file": Files.c, "rank": 8, "piece": Pieces.bishop, "type": PieceTypeT.dark},
  {"file": Files.d, "rank": 8, "piece": Pieces.queen, "type": PieceTypeT.dark},
  {"file": Files.e, "rank": 8, "piece": Pieces.king, "type": PieceTypeT.dark},
  {"file": Files.f, "rank": 8, "piece": Pieces.bishop, "type": PieceTypeT.dark},
  {"file": Files.g, "rank": 8, "piece": Pieces.knight, "type": PieceTypeT.dark},
  {"file": Files.h, "rank": 8, "piece": Pieces.rook, "type": PieceTypeT.dark}
];

bool getAllPieces = false;

enum PieceTypeT { light, dark }

enum Files { a, b, c, d, e, f, g, h }

enum RelativeDirection {
  rankLeft,
  rankRight,
  fileTop,
  fileBottom,
  diagonalTopLeft,
  diagonalTopRight,
  diagonalBottomLeft,
  diagonalBottomRight,
  undefined
}
