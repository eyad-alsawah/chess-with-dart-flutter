import 'package:chess/utils/enums.dart';
import 'package:chess/view/game_widget.dart';
import 'package:flutter/material.dart';

class GameView extends StatefulWidget {
  final bool playOnline;
  const GameView({super.key, this.playOnline = false});

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  String squareName = "";
  List<String> movementHistory = [];
  String currentPlayingTurn = "White's Turn";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 38, 37, 33),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ChessBoard(
            playingAs: PlayingAs.white,
            size: 375,
            onTap: (name) {},
            onPlayingTurnChanged: (playingTurn) {
              currentPlayingTurn = playingTurn == PlayingTurn.white
                  ? "White's Turn"
                  : "Black's Turn";
              setState(() {});
            },
          ),
          Center(
            child: Text(
              currentPlayingTurn,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
