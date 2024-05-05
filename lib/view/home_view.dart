import 'package:chess/controllers/enums.dart';
import 'package:chess/controllers/shared_state.dart';
import 'package:chess/view/game_view.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String squareName = "";
  List<String> movementHistory = [];
  String currentPlayingTurn = "White's Turn";
  Key uniqueKey = UniqueKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 38, 37, 33),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: GestureDetector(
              onTap: () {
                uniqueKey = UniqueKey();
                squareName = "";
                movementHistory = [];
                currentPlayingTurn = "White's Turn";
                SharedState.instance.reset();
                setState(() {});
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Reset Game',
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.restart_alt_rounded,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 50),
          ChessBoard(
            key: uniqueKey,
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
