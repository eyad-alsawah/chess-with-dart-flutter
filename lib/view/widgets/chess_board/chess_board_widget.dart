// import 'package:audioplayers/audioplayers.dart';

import 'package:chess/controllers/enums.dart';
import 'package:chess/controllers/game_controller.dart';
import 'package:chess/controllers/game_status_controller.dart';
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

List<String> filesNotation = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'];
List<String> ranksNotation = ['1', '2', '3', '4', '5', '6', '7', '8'];

class ChessBoard extends StatefulWidget {
  final ValueChanged<PlayingTurn> onPlayingTurnChanged;
  final VoidCallback onUpdateView;
  final VoidCallback onVictory;
  final double size;
  const ChessBoard({
    super.key,
    required this.size,
    required this.onPlayingTurnChanged,
    required this.onUpdateView,
    required this.onVictory,
  });

  @override
  State<ChessBoard> createState() => _ChessBoardState();
}

class _ChessBoardState extends State<ChessBoard> {
  late SharedState state;
  late ChessController chess;
  AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    state = SharedState.instance;
    super.initState();
    chess = ChessController(
      onDraw: (drawType) {},
      fenString: null,
      //fenString:'4k2r/6r1/8/8/8/8/3R4/R3K3 w Qk - 0',
      //  fenString: 'rnbqkbnr/pppp1ppp/8/4p3/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1',
      playSound: (soundType) async {
        AudioPlayer audioPlayer = AudioPlayer();
        switch (soundType) {
          case SoundType.illegal:
            audioPlayer.setAsset(illegalSound);

            break;
          case SoundType.pieceMoved:
            audioPlayer.setAsset(pieceMovedSound);

            break;
          case SoundType.capture:
            audioPlayer.setAsset(captureSound);

            break;
          case SoundType.kingChecked:
            audioPlayer.setAsset(kingCheckedSound);

            break;
          case SoundType.victory:
            audioPlayer.setAsset(victorySound);

            break;
          case SoundType.draw:
            audioPlayer.setAsset(drawSound);

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
        state.selectedIndex =
            highlightedLegalMovesIndices.isEmpty ? null : selectedPieceIndex;
      },
      onPlayingTurnChanged: (playingTurn) =>
          widget.onPlayingTurnChanged(playingTurn),
      onPieceMoved: (from, to) async {
        state.selectedIndex = null;
        ChessController.legalMovesIndices.clear();
        // todo: change the place of this to ensure that its value won't be null after we set it to an Int
        GameStatusController.checkedKingIndex = null;
        await SharedState.instance
            .storeState()
            .then((value) => widget.onUpdateView());
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
                              color: state.debugHighlightIndices.contains(index)
                                  ? Colors.blue
                                  : (GameStatusController.checkedKingIndex !=
                                              null &&
                                          index ==
                                              GameStatusController
                                                  .checkedKingIndex)
                                      ? Colors.red
                                      : (index == state.selectedIndex &&
                                              state.selectedIndex != null)
                                          ? Colors.lightGreen
                                          : getSquareColor(
                                              ignoreTappedIndices: true,
                                              index: index,
                                            ),
                            ),
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
