import 'dart:math';

// import 'package:audioplayers/audioplayers.dart';

import 'package:chess/controllers/enums.dart';
import 'package:chess/controllers/game_controller.dart';
import 'package:chess/utils/image_assets.dart';
import 'package:chess/utils/sound_assets.dart';
import 'package:flutter/material.dart';

import 'package:chess/model/model.dart';

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
  int? checkedKingIndex;

  late ChessController chess;

  @override
  void initState() {
    super.initState();
    chess = ChessController.fromPosition(
      onCheck: (enemyKingIndex) {
        checkedKingIndex = enemyKingIndex;
      },
      playSound: (soundType) async {
        // AudioPlayer audioPlayer = AudioPlayer();
        // switch (soundType) {
        //   case SoundType.illegal:
        //     await audioPlayer.play(volume: 1, AssetSource(illegalSound));
        //     break;
        //   case SoundType.pieceMoved:
        //     await audioPlayer.play(volume: 1, AssetSource(pieceMovedSound));
        //     break;
        //   case SoundType.capture:
        //     await audioPlayer.play(volume: 1, AssetSource(captureSound));
        //     break;
        //   case SoundType.kingChecked:
        //     await audioPlayer.play(volume: 1, AssetSource(kingCheckedSound));
        //     break;
        //   case SoundType.victory:
        //     await audioPlayer.play(volume: 1, AssetSource(victorySound));
        //     break;
        //   case SoundType.draw:
        //     await audioPlayer.play(volume: 1, AssetSource(drawSound));
        //     break;
        //   default:
        // }
      },
      updateView: () {
        setState(() {});
      },
      initialPosition: "initialPosition",
      onVictory: (victoryType) {},
      onDraw: (drawType) {},
      onPawnPromoted: (promotedPieceIndex, promotedTo) async {
        chessBoard[promotedPieceIndex].piece = promotedTo;
      },
      onSelectPromotionType: (playingTurn) async {
        return await showDialog(
            useRootNavigator: true,
            context: context,
            barrierDismissible: false,
            builder: (dialogContext) {
              return AlertDialog(
                contentPadding: EdgeInsets.zero,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                content: Transform.rotate(
                  angle: playingTurn == PlayingTurn.white ? 0 : pi,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Color(0xFFB58863),
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    height: 100,
                    width: 100,
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(dialogContext, rootNavigator: true)
                                  .pop(Pieces.rook);
                            },
                            child: Image.asset(
                              playingTurn == PlayingTurn.white
                                  ? whiteCastle
                                  : blackCastle,
                            ),
                          ),
                        ),
                        Container(
                          width: 2,
                          color: Colors.black,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(dialogContext, rootNavigator: true)
                                  .pop(Pieces.knight);
                            },
                            child: Image.asset(
                              playingTurn == PlayingTurn.white
                                  ? whiteKnight
                                  : blackKnight,
                            ),
                          ),
                        ),
                        Container(
                          width: 2,
                          color: Colors.black,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(dialogContext, rootNavigator: true)
                                  .pop(Pieces.bishop);
                            },
                            child: Image.asset(
                              playingTurn == PlayingTurn.white
                                  ? whiteBishop
                                  : blackBishop,
                            ),
                          ),
                        ),
                        Container(
                          width: 2,
                          color: Colors.black,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(dialogContext, rootNavigator: true)
                                  .pop(Pieces.queen);
                            },
                            child: Image.asset(
                              playingTurn == PlayingTurn.white
                                  ? whiteQueen
                                  : blackQueen,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            });
      },
      onPieceSelected:
          (highlightedLegalMovesIndices, selectedPieceIndex) async {
        selectedIndex = null;
        highlightedLegalMovesIndices.isEmpty
            ? tappedIndices.clear()
            : tappedIndices.addAll(highlightedLegalMovesIndices);
        selectedIndex =
            highlightedLegalMovesIndices.isEmpty ? null : selectedPieceIndex;
      },
      onCastling: (movedRookIndex) {},
      onPlayingTurnChanged: (playingTurn) {
        widget.onPlayingTurnChanged(playingTurn);
      },
      onPieceMoved: (from, to) {
        int fromRank = getRankNameFromIndex(index: from);
        Files fromFile = getFileNameFromIndex(index: to);
        Square fromSquare = chessBoard[from];
        chessBoard[from] = Square(
            rank: fromRank, file: fromFile, piece: null, pieceType: null);

        chessBoard[to] = fromSquare;
        selectedIndex = null;
        tappedIndices.clear();

        // todo: change the place of this to ensure that its value won't be null after we set it to an Int
        checkedKingIndex = null;
      },
      onEnPassant: (capturedPawnIndex) {
        chessBoard[capturedPawnIndex].piece = null;
        chessBoard[capturedPawnIndex].pieceType = null;
      },
      onError: (error, errorString) {
        // AudioPlayer audioPlayer = AudioPlayer();
        // audioPlayer.play(volume: 1, AssetSource(illegalSound));
      },
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
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700),
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
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700),
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
                            color: (checkedKingIndex != null &&
                                    index == checkedKingIndex)
                                ? Colors.red
                                : (index == selectedIndex &&
                                        selectedIndex != null)
                                    ? Colors.lightGreen
                                    : getSquareColor(
                                        ignoreTappedIndices: true,
                                        index: index,
                                        tappedIndices: tappedIndices),
                          ),
                        ),
                      ),
                    ),
                  ),
                  drawInitialPieces(
                      playingAs: PlayingAs.white,
                      boardSize: 375,
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
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700),
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
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700),
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
    squareColor =
        index % 2 == 0 ? const Color(0xFFB58863) : const Color(0xFFF0D9B5);
  } else {
    squareColor =
        index % 2 == 0 ? const Color(0xFFF0D9B5) : const Color(0xFFB58863);
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
          alignment: Alignment.center,
          children: [
            Visibility(
              visible: getImageFromBoard(index: index).isNotEmpty,
              child: Transform.rotate(
                angle: chessBoard[index].pieceType == PieceType.light ? 0 : pi,
                child: Image.asset(
                  height: boardSize * 0.08,
                  width: boardSize * 0.08,
                  getImageFromBoard(index: index),
                ),
              ),
            ),
            Visibility(
              visible: tappedIndices.contains(index),
              child: Container(
                height: 10,
                width: 10,
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
  Square square = chessBoard[index];
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
