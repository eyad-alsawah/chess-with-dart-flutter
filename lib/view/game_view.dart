import 'package:chess/controllers/online_controllers/firebase_controller/firebase_data_source.dart';
import 'package:chess/utils/enums.dart';
import 'package:chess/view/game_widget.dart';
import 'package:flutter/material.dart';

class GameView extends StatefulWidget {
  final String? joinedGameId;
  final String? createdGameId;
  final bool playOnline;

  const GameView(
      {super.key, this.playOnline = false,  this.joinedGameId,required this.createdGameId});

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  String squareName = "";
  List<String> movementHistory = [];
  String currentPlayingTurn = "White's Turn";
  FirebaseDataSource firebaseDataSource = FirebaseDataSource();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 38, 37, 33),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          widget.createdGameId==null ? ChessBoard(
            playingTurn: PlayingTurn.black,
            size: 375,
            onTap: (name) {},
            onPlayingTurnChanged: (playingTurn) {
              currentPlayingTurn = playingTurn == PlayingTurn.white
                  ? "White's Turn"
                  : "Black's Turn";
              setState(() {});
            },
          ):  StreamBuilder(
              stream: firebaseDataSource
                  .waitForPlayerToJoin(roomId: widget.createdGameId!)
                  .stream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return ChessBoard(
                    playingTurn: PlayingTurn.white,
                    size: 375,
                    onTap: (name) {},
                    onPlayingTurnChanged: (playingTurn) {
                      currentPlayingTurn = playingTurn == PlayingTurn.white
                          ? "White's Turn"
                          : "Black's Turn";
                      setState(() {});
                    },
                  );
                }
              }),
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
