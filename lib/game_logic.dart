import 'dart:math';

import 'package:flutter/material.dart';

enum PlayingAs { white, black }

List<List<bool>> chessBoard = [
  [false, true, false, true, false, true, false, true, false],
];
List<String> filesNotation = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];
List<String> ranksNotation = ['1', '2', '3', '4', '5', '6', '7', '8'];

Widget drawBoard({required PlayingAs playingAs, required double size}) {
  if (playingAs == PlayingAs.white) {
    return SizedBox(
      width: size,
      height: size,
      child: Column(children: [
        SizedBox(
          height: size * 0.08,
          child: Row(
            children: [
              SizedBox(
                width: size * 0.08,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: 8,
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      width: size * 0.1,
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
              height: size * 0.8,
              width: size * 0.08,
              child: ListView.builder(
                  itemCount: 8,
                  reverse: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      height: size * 0.1,
                      width: size * 0.08,
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
            SizedBox(
              width: size * 0.8,
              height: size * 0.8,
              child: GridView.builder(
                reverse: true,
                itemCount: 64,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8,
                ),
                itemBuilder: (context, index) => Container(
                  color: getSquareColor(index: index),
                ),
              ),
            ),
            SizedBox(
              height: size * 0.8,
              width: size * 0.08,
              child: ListView.builder(
                  itemCount: 8,
                  reverse: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      height: size * 0.1,
                      width: size * 0.08,
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
          height: size * 0.08,
          child: Row(
            children: [
              SizedBox(
                width: size * 0.08,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: 8,
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      width: size * 0.1,
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
      ]),
    );
  } else {
    return Container();
  }
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
