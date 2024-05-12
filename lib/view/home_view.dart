import 'dart:math';

import 'package:chess/controllers/enums.dart';
import 'package:chess/controllers/shared_state.dart';
import 'package:chess/view/utils/sizes_manager.dart';
import 'package:chess/view/widgets/chess_board/chess_board_widget.dart';
import 'package:chess/view/widgets/drawer_widget.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late ConfettiController _controllerTopCenter;
  void scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _previewController.jumpTo(_previewController.position.maxScrollExtent);
    });
  }

  @override
  void initState() {
    _controllerTopCenter =
        ConfettiController(duration: const Duration(seconds: 10));
    super.initState();
  }

  final ScrollController _previewController = ScrollController();
  @override
  Widget build(BuildContext context) {
    scrollToEnd();
    return Scaffold(
      appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: const Color.fromARGB(255, 38, 37, 33)),
      drawer: DrawerWidget(
        updateView: () => setState(() {}),
        onResetGame: () async {
          await SharedState.instance.reset();
          setState(() {});
          // ignore: use_build_context_synchronously
          Navigator.of(context).pop();
        },
      ),
      backgroundColor: const Color.fromARGB(255, 38, 37, 33),
      body: ConfettiWidget(
        confettiController: _controllerTopCenter,
        blastDirectionality: BlastDirectionality.explosive,
        blastDirection: pi / 2,
        shouldLoop: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: AppSizeH.s50),
            ChessBoard(
              size: 0.95.sw,
              onPlayingTurnChanged: (playingTurn) {
                SharedState.instance.currentPlayingTurn =
                    playingTurn == PlayingTurn.white
                        ? "White's Turn"
                        : "Black's Turn";
              },
              onVictory: () => _controllerTopCenter.play(),
              onUpdateView: () {
                setState(() {});
              },
            ),
            Center(
              child: Text(
                SharedState.instance.currentPlayingTurn,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: AppSizeH.s30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    SharedState.instance.replay(ReplayType.previous);

                    setState(() {});
                  },
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                ),
                Flexible(
                  child: Container(
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.white)),
                    height: AppSizeH.s50,
                    child: ListView.builder(
                      controller: _previewController,
                      scrollDirection: Axis.horizontal,
                      itemCount: stateImages.length,
                      itemBuilder: (context, index) => Container(
                        height: AppSizeH.s50,
                        width: AppSizeW.s50,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: index == stateImages.length - 1
                                  ? Colors.red
                                  : Colors.black),
                          image: DecorationImage(
                            image: MemoryImage(stateImages[index]),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    SharedState.instance.replay(ReplayType.next);
                    setState(() {});
                  },
                  icon:
                      const Icon(Icons.arrow_forward_ios, color: Colors.white),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
