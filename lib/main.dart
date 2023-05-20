import 'dart:math';

import 'package:chess/game_logic.dart';

import 'package:flutter/material.dart';

import 'logic.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 141, 141, 141),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: ChessBoard(
                playingAs: PlayingAs.white,
                size: 330,
                onTap: (name) {
                  // setState(() {
                  //   movementHistory.add("$name, ");
                  //   squareName = name;
                  // });
                }),
          ),
          IconButton(
              onPressed: () {
                //emptying the chess board
                for (var element in chessBoard) {
                  element['piece'] = null;
                  element['type'] = null;
                }
                List<int> insertionIndex = List.generate(64, (index) => index);
                insertionIndex.shuffle();
                for (var newPiece in listToShuffleFrom) {
                  final random = Random();
                  int randomIndex = random.nextInt(insertionIndex.length);
                  insertionIndex.removeAt(randomIndex);
                  chessBoard[randomIndex]['piece'] = newPiece['piece'];
                  chessBoard[randomIndex]['type'] = newPiece['type'];
                }
                setState(() {});
              },
              icon: const Icon(Icons.shuffle))
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
    "type": PieceType.light,
  },
  {"piece": Pieces.knight, "type": PieceType.light},
  {"piece": Pieces.bishop, "type": PieceType.light},
  {"piece": Pieces.queen, "type": PieceType.light},
  {"piece": Pieces.king, "type": PieceType.light},
  {"piece": Pieces.bishop, "type": PieceType.light},
  {"piece": Pieces.knight, "type": PieceType.light},
  {"piece": Pieces.rook, "type": PieceType.light},
  {"piece": Pieces.pawn, "type": PieceType.light},
  {"piece": Pieces.pawn, "type": PieceType.light},
  {"piece": Pieces.pawn, "type": PieceType.light},
  {"piece": Pieces.pawn, "type": PieceType.light},
  {"piece": Pieces.pawn, "type": PieceType.light},
  {"piece": Pieces.pawn, "type": PieceType.light},
  {"piece": Pieces.pawn, "type": PieceType.light},
  {"piece": Pieces.pawn, "type": PieceType.light},
  //-----------------------------------dark----------------------------------
  {"piece": Pieces.pawn, "type": PieceType.dark},
  {"piece": Pieces.pawn, "type": PieceType.dark},
  {"piece": Pieces.pawn, "type": PieceType.dark},
  {"piece": Pieces.pawn, "type": PieceType.dark},
  {"piece": Pieces.pawn, "type": PieceType.dark},
  {"piece": Pieces.pawn, "type": PieceType.dark},
  {"piece": Pieces.pawn, "type": PieceType.dark},
  {"piece": Pieces.pawn, "type": PieceType.dark},
  {"piece": Pieces.rook, "type": PieceType.dark},
  {"piece": Pieces.knight, "type": PieceType.dark},
  {"piece": Pieces.bishop, "type": PieceType.dark},
  {"piece": Pieces.queen, "type": PieceType.dark},
  {"piece": Pieces.king, "type": PieceType.dark},
  {"piece": Pieces.bishop, "type": PieceType.dark},
  {"piece": Pieces.knight, "type": PieceType.dark},
  {"piece": Pieces.rook, "type": PieceType.dark}
];
