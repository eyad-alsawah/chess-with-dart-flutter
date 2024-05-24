import 'dart:math';

import 'package:chess/controllers/enums.dart';
import 'package:chess/controllers/game_controller.dart';
import 'package:chess/core/theme/color_manager.dart';
import 'package:chess/model/square.dart';
import 'package:chess/utils/extensions.dart';
import 'package:chess/utils/image_assets.dart';
import 'package:chess/view/utils/sizes_manager.dart';
import 'package:flutter/material.dart';

String getSquareNameFromIndex({required int index}) {
  index++;
  int rank = (index / 8).ceil();
  String file = Files.values[index - 8 * (rank - 1) - 1].name;
  return "$file$rank";
}

Color getSquareColor({required int index, required bool ignoreTappedIndices}) {
  index++;
  int currentRow = (index / 8).ceil();
  Color squareColor;

  if (ChessController.legalMovesIndices.contains(index - 1) &&
      !ignoreTappedIndices) {
    squareColor = Colors.red;
  } else if (currentRow % 2 == 0) {
    squareColor =
        index % 2 == 0 ? ColorManager.darkSquare : ColorManager.lightSquare;
  } else {
    squareColor =
        index % 2 == 0 ? ColorManager.lightSquare : ColorManager.darkSquare;
  }
  return squareColor;
}

Widget drawInitialPieces({required double boardSize}) {
  return IgnorePointer(
    child: SizedBox(
      width: boardSize * 0.8,
      height: boardSize * 0.8,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        reverse: true,
        itemCount: 64,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8,
        ),
        itemBuilder: (context, index) => Stack(
          alignment: Alignment.center,
          children: [
            Visibility(
              visible: getImageFromBoard(index: index).isNotEmpty,
              child: Transform.rotate(
                angle: (index).toPieceType() == PieceType.light ? 0 : pi,
                child: Image.asset(
                  height: boardSize * 0.08,
                  width: boardSize * 0.08,
                  getImageFromBoard(index: index),
                ),
              ),
            ),
            Visibility(
              visible: ChessController.legalMovesIndices.contains(index),
              child: Container(
                height: AppSizeH.s10,
                width: AppSizeW.s10,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.lightGreen,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

String getImageFromBoard({required int index}) {
  Square square = index.toSquare();
  String imageAssetString = '';
  switch (square.piece) {
    case Pieces.pawn:
      imageAssetString =
          square.pieceType == PieceType.light ? whitePawn : blackPawn;
      break;
    case Pieces.king:
      imageAssetString =
          square.pieceType == PieceType.light ? whiteKing : blackKing;
      break;
    case Pieces.knight:
      imageAssetString =
          square.pieceType == PieceType.light ? whiteKnight : blackKnight;
      break;
    case Pieces.queen:
      imageAssetString =
          square.pieceType == PieceType.light ? whiteQueen : blackQueen;
      break;
    case Pieces.rook:
      imageAssetString =
          square.pieceType == PieceType.light ? whiteCastle : blackCastle;
      break;
    case Pieces.bishop:
      imageAssetString =
          square.pieceType == PieceType.light ? whiteBishop : blackBishop;
      break;
    default:
  }
  return imageAssetString;
}

//-----------------
Files getFileNameFromIndex({required int index}) {
  List<Files> files = [
    Files.a,
    Files.b,
    Files.c,
    Files.d,
    Files.e,
    Files.f,
    Files.g,
    Files.h
  ];
  index++;
  int rank = (index / 8).ceil();
  Files file = files[index - 8 * (rank - 1) - 1];
  return file;
}

int getRankNameFromIndex({required int index}) {
  index++;
  int rank = (index / 8).ceil();
  return rank;
}
