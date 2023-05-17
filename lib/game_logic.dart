import 'dart:math';

import 'package:chess/image_assets.dart';
import 'package:flutter/material.dart';

enum PlayingAs { white, black }

List<List<bool>> chessBoard = [
  [false, true, false, true, false, true, false, true, false],
];
List<String> filesNotation = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'];
List<String> ranksNotation = ['1', '2', '3', '4', '5', '6', '7', '8'];

class ChessBoard extends StatefulWidget {
  final PlayingAs playingAs;
  final ValueChanged<String> onTap;
  final double size;
  const ChessBoard(
      {super.key,
      required this.playingAs,
      required this.size,
      required this.onTap});

  @override
  State<ChessBoard> createState() => _ChessBoardState();
}

class _ChessBoardState extends State<ChessBoard> {
  String squareName = "";
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
                          squareName = getSquareNameFromIndex(index: index);
                          widget.onTap(squareName);
                        },
                        child: Container(
                          color: getSquareColor(index: index),
                        ),
                      ),
                    ),
                  ),
                  // drawInitialPieces(playingAs: playingAs, boardSize: size),
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

Color getSquareColor({required int index}) {
  index++;
  int currentRow = (index / 8).ceil();
  Color squareColor;
  if (currentRow % 2 == 0) {
    squareColor = index % 2 == 0 ? Colors.green : Colors.white;
  } else {
    squareColor = index % 2 == 0 ? Colors.white : Colors.green;
  }
  return squareColor;
}

Widget drawInitialPieces(
    {required PlayingAs playingAs, required double boardSize}) {
  return SizedBox(
    width: boardSize * 0.8,
    height: boardSize * 0.8,
    child: GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      reverse: true,
      itemCount: 64,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 8,
      ),
      itemBuilder: (context, index) =>
          SizedBox(width: 1, child: Image.asset(height: 1, whitePawn)),
    ),
  );
}
