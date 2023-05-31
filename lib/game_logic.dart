import 'dart:math';

import 'package:chess/image_assets.dart';
import 'package:flutter/material.dart';

import 'game.dart';
import 'logic.dart' show chessBoard, PieceTypeT, PiecesT;

enum PlayingAs { white, black }

List<String> filesNotation = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'];
List<String> ranksNotation = ['1', '2', '3', '4', '5', '6', '7', '8'];

class ChessBoard extends StatefulWidget {
  final PlayingAs playingAs;
  final ValueChanged<String> onTap;
  final ValueChanged<PlayingTurn> onPlayingTurnChanged;
  final double size;
  const ChessBoard(
      {super.key,
      required this.playingAs,
      required this.size,
      required this.onTap,
      required this.onPlayingTurnChanged});

  @override
  State<ChessBoard> createState() => _ChessBoardState();
}

class _ChessBoardState extends State<ChessBoard> {
  String squareName = "";
  List<int> tappedIndices = [];
  int? selectedIndex;
  late Chess chess;

  @override
  void initState() {
    super.initState();
    chess = Chess.fromPosition(
      initialPosition: "initialPosition",
      onVictory: (victoryType) {},
      onDraw: (drawType) {},
      onPawnPromoted: (promotedPieceIndex, promotedTo) {
        chessBoard[promotedPieceIndex]['piece'] = PiecesT.queen;

        setState(() {});
      },
      onPieceSelected: (highlightedLegalMovesIndices, selectedPieceIndex) {
        selectedIndex = null;
        highlightedLegalMovesIndices.isEmpty
            ? tappedIndices.clear()
            : tappedIndices.addAll(highlightedLegalMovesIndices);
        selectedIndex =
            highlightedLegalMovesIndices.isEmpty ? null : selectedPieceIndex;
        setState(() {});
      },
      onCastling: (castlingType, playingTurn) {},
      onPlayingTurnChanged: (playingTurn) {
        widget.onPlayingTurnChanged(playingTurn);
      },
      onPieceMoved: (from, to) {
        print("moved from: $from to $to");
        int fromRank = getRankNameFromIndex(index: from);
        Files fromFile = getFileNameFromIndex(index: to);
        Map<String, dynamic> fromSquare = chessBoard[from];
        chessBoard[from] = {
          "file": fromFile,
          "rank": fromFile,
          "piece": null,
          "type": null
        };
        chessBoard[to] = fromSquare;
        selectedIndex = null;
        tappedIndices.clear();
        setState(() {});
      },
      onError: (error, errorString) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Column(
        children: [
          SizedBox(
            height: widget.size * 0.08,
            child: Row(
              children: [
                SizedBox(
                  width: widget.size * 0.08,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: 8,
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      return SizedBox(
                        width: widget.size * 0.1,
                        child: Center(
                          child: Transform.rotate(
                            angle: pi,
                            child: FittedBox(
                              child: Text(
                                filesNotation[index],
                                style: const TextStyle(
                                    fontSize: 9, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              SizedBox(
                height: widget.size * 0.8,
                width: widget.size * 0.08,
                child: ListView.builder(
                    itemCount: 8,
                    reverse: widget.playingAs == PlayingAs.white,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      return SizedBox(
                        height: widget.size * 0.1,
                        width: widget.size * 0.08,
                        child: Center(
                          child: FittedBox(
                            child: Text(
                              ranksNotation[index],
                              style: const TextStyle(
                                  fontSize: 9, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
              Stack(
                children: [
                  SizedBox(
                    width: widget.size * 0.8,
                    height: widget.size * 0.8,
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      reverse: true,
                      itemCount: 64,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 8,
                      ),
                      itemBuilder: (context, index) => GestureDetector(
                        onTap: () {
                          tappedIndices.clear();
                          chess.handleSquareTapped(tappedSquareIndex: index);

                          widget.onTap(squareName);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: getSquareColor(
                                  ignoreTappedIndices: true,
                                  index: index,
                                  tappedIndices: tappedIndices),
                              border: Border.all(
                                  width: 2,
                                  color: (index == selectedIndex &&
                                          selectedIndex != null)
                                      ? Colors.red
                                      : Colors.transparent)),
                          padding: const EdgeInsets.all(10),
                          child: Container(
                              height: 4,
                              width: 4,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: getSquareColor(
                                    ignoreTappedIndices: false,
                                    index: index,
                                    tappedIndices: tappedIndices),
                              )),
                        ),
                      ),
                    ),
                  ),
                  drawInitialPieces(
                      playingAs: PlayingAs.white,
                      boardSize: 330,
                      tappedIndices: tappedIndices),
                ],
              ),
              SizedBox(
                height: widget.size * 0.8,
                width: widget.size * 0.08,
                child: ListView.builder(
                    itemCount: 8,
                    reverse: widget.playingAs == PlayingAs.white,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      return SizedBox(
                        height: widget.size * 0.1,
                        width: widget.size * 0.08,
                        child: Center(
                          child: Transform.rotate(
                            angle: pi,
                            child: FittedBox(
                              child: Text(
                                ranksNotation[index],
                                style: const TextStyle(
                                    fontSize: 9, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
          SizedBox(
            height: widget.size * 0.08,
            child: Row(
              children: [
                SizedBox(
                  width: widget.size * 0.08,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: 8,
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      return SizedBox(
                        width: widget.size * 0.1,
                        child: Center(
                          child: FittedBox(
                            child: Text(
                              filesNotation[index],
                              style: const TextStyle(
                                  fontSize: 9, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String getSquareNameFromIndex({required int index}) {
  index++;
  int rank = (index / 8).ceil();
  String file = filesNotation[index - 8 * (rank - 1) - 1];
  return "$file$rank";
}

Color getSquareColor(
    {required int index,
    required List<int> tappedIndices,
    required bool ignoreTappedIndices}) {
  index++;
  int currentRow = (index / 8).ceil();
  Color squareColor;

  if (tappedIndices.contains(index - 1) && !ignoreTappedIndices) {
    squareColor = Colors.red;
  } else if (currentRow % 2 == 0) {
    squareColor = index % 2 == 0 ? Colors.green : Colors.white;
  } else {
    squareColor = index % 2 == 0 ? Colors.white : Colors.green;
  }
  return squareColor;
}

Widget drawInitialPieces(
    {required PlayingAs playingAs,
    required double boardSize,
    required List<int> tappedIndices}) {
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
          children: [
            Visibility(
                visible: getImageFromBoard(index: index).isNotEmpty,
                child: Image.asset(
                    height: 30, width: 30, getImageFromBoard(index: index))),
            Visibility(
              visible: tappedIndices.contains(index),
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Container(
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.red),
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
  Map<String, dynamic> square = chessBoard[index];
  String imageAssetString = '';
  switch (square['piece']) {
    case PiecesT.pawn:
      imageAssetString =
          square['type'] == PieceTypeT.light ? whitePawn : blackPawn;
      break;
    case PiecesT.king:
      imageAssetString =
          square['type'] == PieceTypeT.light ? whiteKing : blackKing;
      break;
    case PiecesT.knight:
      imageAssetString =
          square['type'] == PieceTypeT.light ? whiteKnight : blackKnight;
      break;
    case PiecesT.queen:
      imageAssetString =
          square['type'] == PieceTypeT.light ? whiteQueen : blackQueen;
      break;
    case PiecesT.rook:
      imageAssetString =
          square['type'] == PieceTypeT.light ? whiteCastle : blackCastle;
      break;
    case PiecesT.bishop:
      imageAssetString =
          square['type'] == PieceTypeT.light ? whiteBishop : blackBishop;
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
