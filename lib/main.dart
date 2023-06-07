import 'dart:math';

import 'package:chess/game_controller.dart';
import 'package:chess/game_view.dart';

import 'package:flutter/material.dart';

import 'model.dart' hide Pieces;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String squareName = "";
  List<String> movementHistory = [];
  String currentPlayingTurn = "White's Turn";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 38, 37, 33),
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
          // const SizedBox(height: 20),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 30),
          //   child: SizedBox(
          //     height: 100,
          //     child: SingleChildScrollView(
          //       child: Text(
          //         movementHistory.join(),
          //         style: const TextStyle(
          //             fontSize: 10, fontWeight: FontWeight.bold),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

List<Map<String, dynamic>> listToShuffleFrom = [
  {
    "piece": Pieces.rook,
    "type": PieceTypeT.light,
  },
  {"piece": Pieces.knight, "type": PieceTypeT.light},
  {"piece": Pieces.bishop, "type": PieceTypeT.light},
  {"piece": Pieces.queen, "type": PieceTypeT.light},
  {"piece": Pieces.king, "type": PieceTypeT.light},
  {"piece": Pieces.bishop, "type": PieceTypeT.light},
  {"piece": Pieces.knight, "type": PieceTypeT.light},
  {"piece": Pieces.rook, "type": PieceTypeT.light},
  {"piece": Pieces.pawn, "type": PieceTypeT.light},
  {"piece": Pieces.pawn, "type": PieceTypeT.light},
  {"piece": Pieces.pawn, "type": PieceTypeT.light},
  {"piece": Pieces.pawn, "type": PieceTypeT.light},
  {"piece": Pieces.pawn, "type": PieceTypeT.light},
  {"piece": Pieces.pawn, "type": PieceTypeT.light},
  {"piece": Pieces.pawn, "type": PieceTypeT.light},
  {"piece": Pieces.pawn, "type": PieceTypeT.light},
  //-----------------------------------dark----------------------------------
  {"piece": Pieces.pawn, "type": PieceTypeT.dark},
  {"piece": Pieces.pawn, "type": PieceTypeT.dark},
  {"piece": Pieces.pawn, "type": PieceTypeT.dark},
  {"piece": Pieces.pawn, "type": PieceTypeT.dark},
  {"piece": Pieces.pawn, "type": PieceTypeT.dark},
  {"piece": Pieces.pawn, "type": PieceTypeT.dark},
  {"piece": Pieces.pawn, "type": PieceTypeT.dark},
  {"piece": Pieces.pawn, "type": PieceTypeT.dark},
  {"piece": Pieces.rook, "type": PieceTypeT.dark},
  {"piece": Pieces.knight, "type": PieceTypeT.dark},
  {"piece": Pieces.bishop, "type": PieceTypeT.dark},
  {"piece": Pieces.queen, "type": PieceTypeT.dark},
  {"piece": Pieces.king, "type": PieceTypeT.dark},
  {"piece": Pieces.bishop, "type": PieceTypeT.dark},
  {"piece": Pieces.knight, "type": PieceTypeT.dark},
  {"piece": Pieces.rook, "type": PieceTypeT.dark}
];
