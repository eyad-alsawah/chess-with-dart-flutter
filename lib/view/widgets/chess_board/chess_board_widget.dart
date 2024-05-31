import 'package:chess/controllers/enums.dart';
import 'package:chess/controllers/game_controller.dart';
import 'package:chess/controllers/shared_state.dart';
import 'package:chess/utils/colored_printer.dart';
import 'package:chess/utils/global_keys.dart';
import 'package:chess/utils/sound_assets.dart';
import 'package:chess/view/widgets/chess_board/files_notation_indicator.dart';
import 'package:chess/view/widgets/chess_board/helper_methods.dart';
import 'package:chess/view/widgets/chess_board/promotion_type_selection_dialog.dart';
import 'package:chess/view/widgets/chess_board/ranks_notation_indicator.dart';
import 'package:flutter/material.dart';

import 'package:just_audio/just_audio.dart';

class ChessBoard extends StatefulWidget {
  final VoidCallback onUpdateView;
  final VoidCallback onVictory;
  final double size;
  const ChessBoard({
    super.key,
    required this.size,
    required this.onUpdateView,
    required this.onVictory,
  });

  @override
  State<ChessBoard> createState() => _ChessBoardState();
}

class _ChessBoardState extends State<ChessBoard> {
  late ChessController chess;
  AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    chess = ChessController(
      fenString: null,
      onDraw: (drawType) {},
      playSound: (soundType) async {
        switch (soundType) {
          case SoundType.illegal:
            await audioPlayer.setAsset(illegalSound);
            break;
          case SoundType.pieceMoved:
            await audioPlayer.setAsset(pieceMovedSound);
            break;
          case SoundType.capture:
            await audioPlayer.setAsset(captureSound);
            break;
          case SoundType.kingChecked:
            await audioPlayer.setAsset(kingCheckedSound);
            break;
          case SoundType.victory:
            await audioPlayer.setAsset(victorySound);
            break;
          case SoundType.draw:
            await audioPlayer.setAsset(drawSound);
            break;
          default:
        }
        if (audioPlayer.audioSource != null) {
          audioPlayer.play();
        }
      },
      updateView: () => widget.onUpdateView(),
      onVictory: (victoryType) => widget.onVictory(),
      onSelectPromotionType: (playingTurn) async =>
          showPromotionTypeSelectionDialog(playingTurn, context),
      onPieceSelected:
          (highlightedLegalMovesIndices, selectedPieceIndex) async {
        SharedState.instance.selectedIndex =
            highlightedLegalMovesIndices.isEmpty ? null : selectedPieceIndex;
      },
      onError: (error, errorString) {
        // todo: show a toast here
        ColoredPrinter.printColored(
            "error: \n$error, $errorString", AnsiColor.red);
        ColoredPrinter.printColored('', AnsiColor.reset);
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
          FilesNotationIndicator(size: widget.size, top: true),
          Row(
            children: [
              RanksNotationIndicator(size: widget.size, right: false),
              RepaintBoundary(
                key: GlobalKeys.captureKey,
                child: Stack(
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
                          onTap: () => chess.handleSquareTapped(index),
                          child: Container(
                            decoration: BoxDecoration(
                              color: SharedState.instance.debugHighlightIndices
                                      .contains(index)
                                  ? Colors.blue
                                  : (SharedState.instance.checkedKingIndex !=
                                              null &&
                                          index ==
                                              SharedState
                                                  .instance.checkedKingIndex)
                                      ? Colors.red
                                      : (index ==
                                                  SharedState
                                                      .instance.selectedIndex &&
                                              SharedState
                                                      .instance.selectedIndex !=
                                                  null)
                                          ? Colors.lightGreen
                                          : getSquareColor(
                                              ignoreTappedIndices: true,
                                              index: index,
                                            ),
                            ),
                            // child: Text('$index'),
                          ),
                        ),
                      ),
                    ),
                    drawInitialPieces(
                      boardSize: widget.size,
                    ),
                  ],
                ),
              ),
              RanksNotationIndicator(size: widget.size, right: true),
            ],
          ),
          FilesNotationIndicator(size: widget.size, top: false),
        ],
      ),
    );
  }
}
